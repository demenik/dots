{
  name = "kitty";

  modules = [
    ./default.nix
  ];
  moduleConfig = {
    pkgs,
    lib,
    ...
  }: {
    terminal = {
      command = lib.getExe pkgs.kitty;
      windowClass = "kitty";
    };
  };

  home = {config, ...}: let
    c = config.colors.withHashtag;
  in {
    programs.kitty = {
      enable = true;
      settings = {
        shell = config.shell.command;

        confirm_os_window_close = 0;
        dynamic_background_opacity = true;
        disable_ligatures = "always";

        foreground = c.base05;
        background = c.base00;
        selection_foreground = c.base00;
        selection_background = c.base06;

        cursor = c.base05;
        cursor_text_color = c.base00;

        url_color = c.base0E;

        color0 = c.base00;
        color8 = c.base03;
        color1 = c.base08;
        color9 = c.base08;
        color2 = c.base0B;
        color10 = c.base0B;
        color3 = c.base0A;
        color11 = c.base0A;
        color4 = c.base0D;
        color12 = c.base0D;
        color5 = c.base0E;
        color13 = c.base0E;
        color6 = c.base0C;
        color14 = c.base0C;
        color7 = c.base05;
        color15 = c.base07;

        background_opacity = "0.825";
        window_padding_width = 0;
        active_border_color = c.base0D;
        inactive_border_color = c.base01;
      };

      font.name = builtins.elemAt config.fonts.fontconfig.defaultFonts.monospace 0;

      shellIntegration.enableZshIntegration = true;
    };

    home.shellAliases = {
      ssh = "kitten ssh";
    };
  };
}
