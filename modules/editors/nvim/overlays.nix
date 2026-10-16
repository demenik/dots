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
      rev = "0228b3b9aad2bf091fc72534c23a2751e7d649de";
      hash = "sha256-0f/CnB7s/URokTYWV/rbJuOzFTGLi+4obIL9izPmxX8=";
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
            rev = "e5199e8036420d2a1d56f54b5e4a85cd21692237";
            hash = "sha256-XaA7iujjRApOpFzDTITUjs+SXuc11vOgbUylyDRVbXk=";
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
            rev = "26592d8fab2a4c133d2a5d95e90d2ba54eb3c018";
            hash = "sha256-SXlI2M2BjNKEbReqTnNXITmryAboPjQJmq1IcgAMc5A=";
          };
        };

        diffview-nvim = final.vimUtils.buildVimPlugin {
          pname = "diffview.nvim";
          version = "latest";
          src = final.fetchFromGitHub {
            owner = "dlyongemallo";
            repo = "diffview.nvim";
            rev = "2a2d89a07f5d5d3cef7f542b99c3e28050ca205c";
            hash = "sha256-0Zu2HPU9rzsyIOVLPWB9ABmfu5UffYkJtkIQUtBLVOs=";
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
