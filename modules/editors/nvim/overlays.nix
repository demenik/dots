[
  (final: prev: {
    rage-wrapped = final.writeShellScriptBin "rage" ''
      TMP_FILE=$(mktemp)
      cat > "$TMP_FILE"

      is_empty=0
      if [ ! -s "$TMP_FILE" ]; then is_empty=1; fi

      is_decrypt=0
      for arg in "$@"; do
        if [ "$arg" = "-d" ] || [ "$arg" = "--decrypt" ]; then
          is_decrypt=1
          break
        fi
      done

      if [ "$is_empty" -eq 1 ] && [ "$is_decrypt" -eq 1 ]; then
        rm "$TMP_FILE"
        exit 0
      fi

      if [ "$is_decrypt" -eq 0 ]; then
        set -- "$@" -R "$HOME/.ssh/id_agenix.pub"
      fi

      cat "$TMP_FILE" | ${final.lib.getExe final.rage} "$@"
      EXIT_CODE=$?
      rm "$TMP_FILE"
      exit $EXIT_CODE
    '';

    gitlabNvimSrc = final.fetchFromGitHub {
      owner = "harrisoncramer";
      repo = "gitlab.nvim";
      rev = "main";
      hash = "sha256-qLiXbeN4+14eJrfespCNc+p3qr1KCKurysbPuTsB4J8=";
    };

    gitlab-nvim-server = final.buildGoModule {
      pname = "gitlab-nvim-server";
      version = "latest";
      src = final.gitlabNvimSrc;

      vendorHash = "sha256-OLAKTdzqynBDHqWV5RzIpfc3xZDm6uYyLD4rxbh0DMg=";

      postBuild = ''
        mkdir -p "$GOPATH"/bin
        mv "$GOPATH"/bin/* "$GOPATH"/bin/server 2>/dev/null || true
      '';
    };

    kotlin-lsp = final.callPackage (
      {
        lib,
        stdenv,
        fetchzip,
        makeWrapper,
        autoPatchelfHook,
        zlib,
      }:
        stdenv.mkDerivation rec {
          pname = "kotlin-lsp";
          version = "262.4739.0";

          src = fetchzip {
            url = "https://download-cdn.jetbrains.com/kotlin-lsp/${version}/kotlin-server-${version}.tar.gz";
            hash = "sha256-V4w2gnwJCrW0+iNyKrGsd+wXGBUoI/BoVYSxlHVzo64=";
            stripRoot = false;
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

            makeWrapper "$TARGET_BIN" "$out"/bin/kotlin-lsp

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

    silicon-theme-catppuccin = final.fetchFromGitHub {
      owner = "catppuccin";
      repo = "sublime-text";
      rev = "3d8625d937d89869476e94bc100192aa220ce44a";
      hash = "sha256-3ABUsfJpb6RO6AiuuSL5gwDofJIwC5tlEMzBrlY9/s0=";
    };

    vimPlugins = prev.vimPlugins // {
      scrollEOF = final.vimUtils.buildVimPlugin {
        pname = "scrollEOF.nvim";
        version = "09-14-2025";
        src = final.fetchFromGitHub {
          owner = "Aasim-A";
          repo = "scrollEOF.nvim";
          rev = "e462b9a07b8166c3e8011f1dcbc6bf68b67cd8d7";
          hash = "sha256-y7yOCRSGTtQcFyWVkGe3xQqstHZMQKayxtqkOVlZ4PM=";
        };
      };

      age-secret-nvim = final.vimUtils.buildVimPlugin {
        pname = "age-secret";
        version = "2025-04-21";
        src = final.fetchFromGitHub {
          owner = "histrio";
          repo = "age-secret.nvim";
          rev = "9be5fbdac534422dc7d03eccb9d5af96f242e16f";
          hash = "sha256-3RMSaUfZyMq9aNwBrdVIP4Mh80HwIcO7I+YhFOw+NU8=";
        };
      };

      sops-nvim = final.vimUtils.buildVimPlugin {
        pname = "sops";
        version = "2025-10-27";
        src = final.fetchFromGitHub {
          owner = "trixnz";
          repo = "sops.nvim";
          rev = "5946285744ffef26b792839d9130135365bfa8ea";
          hash = "sha256-6BFgZSQwrh218genHjnldv1xnCjx4PIoXZcFYKVBlGo=";
        };
      };

      diffview-nvim = final.vimUtils.buildVimPlugin {
        pname = "diffview.nvim";
        version = "latest";
        src = final.fetchFromGitHub {
          owner = "dlyongemallo";
          repo = "diffview.nvim";
          rev = "main";
          hash = "sha256-S5j1W8mQviTXTIdgWBWiY/6ZcX92iAamY2z0eUfe2ng=";
        };
        doCheck = false;
      };

      gitlab-nvim = final.vimUtils.buildVimPlugin {
        pname = "gitlab.nvim";
        version = "latest";
        src = final.gitlabNvimSrc;

        dependencies = with final.vimPlugins; [
          nui-nvim
          plenary-nvim
        ];

        doCheck = false;
        postInstall = ''
          mkdir -p "$out"/bin
          ln -s "${final.gitlab-nvim-server}"/bin/server "$out"/bin/server
        '';
      };

      silicon-nvim = final.vimUtils.buildVimPlugin {
        pname = "silicon.nvim";
        version = "12-03-2024";
        src = final.fetchFromGitHub {
          owner = "krivahtoo";
          repo = "silicon.nvim";
          rev = "d8a6852b7158cc98f44ab12a0811ccf7d111dc71";
          hash = "sha256-3ABUsfJpb6RO6AiuuSL5gwDofJIwC5tlEMzBrlY9/s0=";
        };
      };
    };
  })
]
