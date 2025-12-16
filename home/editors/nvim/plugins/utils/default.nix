{
  imports = [
    ./lualine
    ./toggleterm.nix
    ./which-key
    ./fzf-lua.nix
    ./grug-far.nix
    ./presence.nix
    ./silicon.nix
    ./todo-comments.nix
    ./debugging.nix
    ./snacks
  ];

  plugins = {
    nix-develop = {
      enable = true;
      ignoredVariables = {
        SHELL = false;
      };
    };
    wakatime.enable = true;
  };

  extraConfigLua =
    #lua
    ''
      vim.api.nvim_create_autocmd("VimEnter", {
        desc = "Automatically enter Nix devshell",
        command = "NixDevelop",
      })
    '';
}
