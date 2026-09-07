{
  home = {
    pkgs,
    lib,
    ...
  }: let
    version = "1.4.0";

    src = pkgs.fetchFromGitHub {
      owner = "levi-qiao";
      repo = "herdr-agent-quota";
      rev = "v${version}";
      hash = "sha256-DB3rCRHtT+zYdFY00wIztXyAGy/JFZLzzr+eaKRfKsU=";
    };

    bin = pkgs.rustPlatform.buildRustPackage {
      pname = "herdr-agent-quota";
      inherit version src;
      cargoHash = "sha256-PMI+ICRfOb8Oa2LxLGjBnoMDxor+k3a1mUDuCDIc3gw=";
      doCheck = false;
    };

    settings = {
      agent = "all";
      sidebar-layout = "stacked";
      fields = "model,cache,ttl,context,5h,7d";
      quota-percent = "used";
      brand-colors = "on";
      row-gap = 1;
      agent-order = "default";
      low-quota-alert = "off";
      watch-interval-seconds = 60;
    };
  in {
    programs.herdr.plugins = [
      {
        package = pkgs.runCommand "herdr-agent-quota-${version}" {} ''
          cp -r "${src}" "$out"
          chmod -R u+w "$out"
          install -Dm755 "${bin}"/bin/herdr-agent-quota "$out"/target/release/herdr-agent-quota
        '';

        id = "herdr-agent-quota";
        reloadConfig = true;
        setup =
          # sh
          ''
            run env HERDR_BIN_PATH="$HERDR" \
              ${bin}/bin/herdr-agent-quota configure --apply \
              ${lib.cli.toGNUCommandLineShell {} settings} \
              >/dev/null 2>&1 || true
          '';
      }
    ];
  };
}
