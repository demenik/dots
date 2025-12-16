{pkgs, ...}: {
  programs.nixvim = {
    extraPlugins = with pkgs.vimPlugins; [SchemaStore-nvim];

    extraPackages = let
      kotlin-lsp = pkgs.callPackage ./kotlin-lsp.nix {};
    in
      with pkgs; [
        kotlin-lsp
        ltex-ls-plus
      ];

    plugins = {
      jdtls.enable = true;
    };

    lsp.servers = {
      "*".config = {
        root_markers = [
          ".git"
          "flake.nix"
        ];
      };

      bashls.enable = true;
      nixd.enable = true;
      lua_ls = {
        enable = true;
        config.on_init.__raw =
          # lua
          ''
            function(client)
              if client.workspace_folders then
                local path = client.workspace_folders[1].name
                if
                  path ~= vim.fn.stdpath('config')
                  and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
                then
                  return
                end
              end
              client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                runtime = {
                  version = 'LuaJIT',
                  path = {
                    'lua/?.lua',
                    'lua/?/init.lua',
                  },
                },
                workspace = {
                  checkThirdParty = false,
                  library = {
                    vim.env.VIMRUNTIME
                  }
                }
              })
            end
          '';
      };

      ltex_plus = {
        enable = true;
        config = let
          inherit (import ./ltex.nix) filetypes enabled dictionary;
        in {
          inherit filetypes;
          settings.ltex = {
            inherit enabled;
            languageToolHttpServerUri = "https://languagetool.demenik.dev";
            language = "en-US";
            additionalRules.motherTongue = "de-DE";
            inherit dictionary;
          };
        };
      };

      html.enable = true;
      ts_ls.enable = true;
      cssls.enable = true;
      eslint.enable = true;
      tailwindcss.enable = true;

      taplo.enable = true;
      jsonls = {
        enable = true;
        config.json = {
          schemas.__raw = "require('schemastore').json.schemas()";
          validate.enable = true;
        };
      };
      yamlls = {
        enable = true;
        config.yaml = {
          schemaStore = {
            enable = false;
            url = "";
          };
          schemas.__raw = "require('schemastore').yaml.schemas()";
        };
      };

      texlab.enable = true;
      marksman.enable = true;

      sqruff = {
        enable = true;
        config.sqruff.indentation = {
          indent_unit = "space";
          tab_space_size = 2;
        };
      };
      graphql.enable = true;

      dockerls.enable = true;
      docker_compose_language_service.enable = true;

      gopls.enable = true;
      dartls.enable = true;
      pylyzer.enable = true;
      solargraph.enable = true;
      gdscript.enable = true;

      jdtls.enable = true;
      kotlin_lsp.enable = true;

      # also see lang/rust.nix
      rust_analyzer = {
        enable = true;
        packageFallback = true;
        config.rust-analyzer = {
          procMacro.enable = true;
          check = {
            command = "clippy";
            allTargets = false;
          };
          cargo.allFeatures = true;
        };
      };
      clangd.enable = true;
      cmake.enable = true;

      glslls.enable = true;

      qmlls.enable = true;
    };
  };
}
