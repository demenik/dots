{pkgs, ...}: let
  theme = "${pkgs.silicon-theme-catppuccin}/Mocha.tmTheme";
  font = "JetBrainsMono Nerd Font=16;Noto Color Emoji=16";
in {
  programs.nixvim = {
    extraPackages = with pkgs; [
      silicon
      jetbrains-mono
      noto-fonts-color-emoji
    ];

    extraPlugins = [pkgs.vimPlugins.silicon-nvim];

    extraConfigLua =
      # lua
      ''
        require("silicon").setup {
          font = "${font}",
          theme = "${theme}",
          window_controls = false,
          output = {
            path = "~/Downloads",
          },
        }
      '';
  };
}
