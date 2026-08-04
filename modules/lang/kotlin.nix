{lib, ...}: {
  name = "lang-kotlin";

  moduleOptions = with lib; {
    lang.kotlin = {
      enable = mkEnableOption "Enable Kotlin language tools";
      onPath = mkOption {
        type = types.bool;
        default = true;
        description = "Add Kotlin lsp/linter/formatter tools to PATH";
      };
    };
  };

  overlays.home = [
    (final: prev: {
      kotlin-lsp = final.callPackage (
        {
          lib,
          stdenv,
          fetchurl,
          makeWrapper,
          autoPatchelfHook,
          zlib,
          jq,
        }:
          stdenv.mkDerivation rec {
            pname = "kotlin-lsp";
            version = "262.9593.0";

            passthru.fmUpdate = {
              inherit version;
              script = "curl -s https://api.github.com/repos/Kotlin/kotlin-lsp/releases/latest | ${lib.getExe jq} -r '.name | ltrimstr(\"v\")'";
            };

            src = fetchurl {
              url = "https://download-cdn.jetbrains.com/language-server/kotlin-server/${version}/kotlin-server-${version}.tar.gz";
              hash = "sha256-LZnY4Zj75KqPRIHjd5lyTOlIA7TqEqYLQWBA4/zXzF4=";
            };

            nativeBuildInputs = [
              makeWrapper
              autoPatchelfHook
            ];
            buildInputs = [
              stdenv.cc.cc.lib
              zlib
            ];

            autoPatchelfIgnoreMissingDeps = true;

            installPhase = ''
              runHook preInstall

              cd kotlin-server-* || cd .

              rm -f bin/libgcompat-ext.so

              mkdir -p "$out"/bin "$out"/libexec/kotlin-lsp
              cp -r * "$out"/libexec/kotlin-lsp/

              TARGET_BIN="$out/libexec/kotlin-lsp/bin/intellij-server"
              chmod +x "$TARGET_BIN"

              makeWrapper "$TARGET_BIN" "$out"/bin/intellij-server

              runHook postInstall
            '';

            meta = {
              description = "Kotlin Language Server (Standalone Binary)";
              homepage = "https://github.com/Kotlin/kotlin-lsp";
              license = lib.licenses.asl20;
              platforms = lib.platforms.linux;
            };
          }
      ) {};
    })
  ];

  home = {
    pkgs,
    lib,
    config,
    ...
  }: let
    cfg = config.lang.kotlin;
    packages = {
      inherit (pkgs) ktlint;
      kotlin_lsp = pkgs.kotlin-lsp;
    };
  in
    lib.mkIf cfg.enable {
      home.packages = lib.mkIf cfg.onPath (lib.unique (builtins.attrValues packages));

      lang.meta.kotlin = {
        enable = true;
        inherit packages;
        lsps = ["kotlin_lsp"];
        linters = {
          kotlin = ["ktlint"];
        };
        formatters = {
          kotlin = ["ktlint"];
        };
      };

      programs.claude-code.plugins = lib.mkIf config.programs.claude-code.enable {
        "kotlin-lsp" = "${pkgs.claude-plugins}/plugins/kotlin-lsp";
      };
    };
}
