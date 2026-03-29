{
  lib,
  config,
  ...
}: {
  imports = [
    ./lualine
    ./snacks
    ./debugging.nix
    ./fzf-lua.nix
    ./grug-far.nix
    ./leetcode.nix
    ./opencode.nix
    ./presence.nix
    ./scrollback.nix
    # ./silicon.nix
    ./todo-comments.nix
    ./toggleterm.nix
    ./which-key.nix
  ];

  programs.nixvim = {
    plugins = {
      nix-develop = {
        enable = false;
        ignoredVariables = {
          SHELL = false;
        };
      };
      wakatime.enable = true;
      vim-suda = {
        enable = true;
        settings.smart_edit = 1;
      };
    };

    # extraConfigLua =
    #   #lua
    #   ''
    #     vim.api.nvim_create_autocmd("VimEnter", {
    #       desc = "Automatically enter Nix devshell",
    #       callback = function()
    #         if vim.fn.filereadable "flake.nix" == 1 then
    #           vim.cmd "NixDevelop"
    #         end
    #       end,
    #     })
    #   '';
  };

  home.file.".wakatime.cfg" = lib.mkIf (lib.hasAttr "wakatime" config.sops.secrets) {
    source = config.lib.file.mkOutOfStoreSymlink config.sops.secrets.wakatime.path;
  };
}
