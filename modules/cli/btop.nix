{
  name = "btop";

  home = {
    pkgs,
    lib,
    config,
    ...
  }: {
    programs.btop = {
      enable = true;
      settings = {
        color_theme =
          if config.theme.type == "colorScheme"
          then "catppuccin-mocha"
          else "noctalia";
        theme_background = false;
      };
      themes = lib.mkIf (config.theme.type == "colorScheme") {
        catppuccin-mocha = pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/catppuccin/btop/f437574b600f1c6d932627050b15ff5153b58fa3/themes/catppuccin_mocha.theme";
          sha256 = "0i263xwkkv8zgr71w13dnq6cv10bkiya7b06yqgjqa6skfmnjx2c";
        };
      };
    };

    theme.templates.btop.enable = true;
  };
}
