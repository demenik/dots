{
  name = "zotero";

  overlays.home = [
    (final: prev: {
      zotero-bin = final.stdenv.mkDerivation (finalAttrs: {
        pname = "zotero-bin";
        version = "10.0.6";

        passthru.fmUpdate = {
          inherit (finalAttrs) version;
          script = "${final.lib.getExe final.curl} -sIL -o /dev/null -w '%{url_effective}' 'https://www.zotero.org/download/client/dl?channel=release&platform=linux-x86_64' | ${final.lib.getExe final.gnugrep} -oP 'release/\\K[^/]+'";
        };

        src = final.fetchurl {
          url = "https://download.zotero.org/client/release/${finalAttrs.version}/Zotero-${finalAttrs.version}_linux-x86_64.tar.xz";
          hash = "sha256-JGwldKmsUmq+rzAn/9IvxFU2pasl8ie7Hfky/KnO3WM=";
        };

        nativeBuildInputs = with final; [
          autoPatchelfHook
          makeShellWrapper
          patchelfUnstable
          unzip
          wrapGAppsHook3
          zip
        ];

        buildInputs = with final; [
          alsa-lib
          dbus-glib
          gtk3
          libxtst
          stdenv.cc.cc
        ];

        runtimeDependencies = with final; [
          curl
          libGL
          libpulseaudio
          libva.out
          pciutils
          udev
        ];

        appendRunpaths = ["${final.pipewire}/lib"];

        patchelfFlags = ["--no-clobber-old-sections"];

        dontConfigure = true;
        dontBuild = true;
        dontWrapGApps = true;

        preFixup = ''
          makeShellWrapper "$out"/lib/zotero/zotero "$out"/bin/zotero "''${gappsWrapperArgs[@]}"
        '';

        postPatch = ''
          mkdir omni
          unzip -q app/omni.ja -d omni
          substituteInPlace omni/integration/libreoffice/resource/installer.mjs \
            --replace-fail "if (optDir.exists()) {" \
            'potentialLocations = potentialLocations.concat((Services.env.get("PATH") || "").split(":").filter(Boolean).map(dir => dir + "/unopkg"));
              if (optDir.exists() && optDir.isReadable()) {'
          rm app/omni.ja
          (cd omni && zip -qr9XD ../app/omni.ja .)
          rm -r omni
        '';

        installPhase = ''
          runHook preInstall

          mkdir -p "$out"/lib/zotero
          cp -r . "$out"/lib/zotero

          install -Dm644 zotero.desktop "$out"/share/applications/zotero.desktop
          sed -i \
            -e 's|^Exec=.*|Exec=zotero -url %U|' \
            -e 's|^Icon=.*|Icon=zotero|' \
            "$out"/share/applications/zotero.desktop
          for size in 32 64 128; do
            install -Dm644 icons/icon$size.png "$out"/share/icons/hicolor/''${size}x''${size}/apps/zotero.png
          done

          runHook postInstall
        '';

        meta = {
          description = "Collect, organize, cite, and share your research sources";
          homepage = "https://www.zotero.org";
          license = final.lib.licenses.agpl3Only;
          platforms = ["x86_64-linux"];
          mainProgram = "zotero";
        };
      });
    })
  ];

  home = {
    pkgs,
    lib,
    config,
    firefoxAddons,
    ...
  }: {
    home.packages = with pkgs; [zotero-bin];

    ai.mcp.zotero = {
      type = "local";
      command = [(lib.getExe' pkgs.uv "uvx") "--python" (lib.getExe pkgs.python3) "zotero-mcp-server"];
      env = {
        ZOTERO_LOCAL.text = "true";
        UV_PYTHON_DOWNLOADS.text = "never";
      };
    };

    programs.librewolf.profiles.default.extensions.packages = lib.mkIf config.programs.librewolf.enable [
      firefoxAddons.zotero-connector
    ];
  };
}
