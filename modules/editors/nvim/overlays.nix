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
      rev = "4cffce85262b393705fbd34a9fadade8f9f1c569";
      hash = "sha256-v/pXII46UtDuteopKBGmHTaEsQoJC1qrZBBrzpW1zeo=";
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

    silicon-theme-catppuccin = final.fetchFromGitHub {
      owner = "catppuccin";
      repo = "sublime-text";
      rev = "3cbaf58c39d1b1fddb8d7d816ecd71977e542b7d";
      hash = "sha256-IJkxrZwwZ3IgASJXqcMRBzkdOY87Ft/PUHtUoU4F/4g=";
    };

    vimPlugins =
      prev.vimPlugins
      // {
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
            rev = "4de0cb71746d7a6de6311c85bc39873e56bcefc7";
            hash = "sha256-pMnAGm7tkgM5pxhNEs06Qdx69qztMd14uNpuRi4I4qE=";
          };
        };

        diffview-nvim = final.vimUtils.buildVimPlugin {
          pname = "diffview.nvim";
          version = "latest";
          src = final.fetchFromGitHub {
            owner = "dlyongemallo";
            repo = "diffview.nvim";
            rev = "62dc5adf4e77489a2a6d3bf36ef6e4ac5738b634";
            hash = "sha256-yqFT+Iastcr3YxlqjKtlDzuEvcw7oSLDGAdcEiodvs0=";
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
            hash = "sha256-OPl1zSaf3pZKyuFj3uod4pEkAM6+G9XnEVSHtm4UiYQ=";
          };
        };
      };
  })
]
