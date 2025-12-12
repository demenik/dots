{pkgs, ...}: {
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
          require("rustaceanvim.config").get_codelldb_adapter(
            "${codelldbPath}",
            "${liblldbPath}"
          )
        '';
      };
    };
  };
}
