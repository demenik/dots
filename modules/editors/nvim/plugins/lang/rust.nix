{pkgs, ...}: {
  programs.nixvim = {
    extraPackages = with pkgs; [
      rustfmt
      clippy
    ];

    lsp.servers.rust_analyzer = {
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

    plugins = {
      crates.enable = true;

      rustaceanvim = {
        enable = false;
        settings = {
          server = {
            cmd = ["rust-analyzer"];
            default_settings.rust-analyzer = {
              procMacro.enable = true;
              check = {
                command = "clippy";
                allTargets = false;
              };
              cargo.allFeatures = true;
            };
          };
          dap.adapter.__raw = let
            codelldb = pkgs.vscode-extensions.vadimcn.vscode-lldb;
            extensionPath = "${codelldb}/share/vscode/extensions/vadimcn.vscode-lldb";
            codelldbPath = "${extensionPath}/adapter/codelldb";
            liblldbPath = "${extensionPath}/lldb/lib/liblldb.so";
          in ''
            require("rustaceanvim.config").get_codelldb_adapter("${codelldbPath}", "${liblldbPath}")
          '';
        };
      };

      lint.lintersByFt.rust = ["clippy"];

      conform-nvim.settings.formatters_by_ft.rust = ["rustfmt"];
    };
  };
}
