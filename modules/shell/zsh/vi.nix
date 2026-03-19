{
  pkgs,
  config,
  ...
}: let
  inherit (config) colors;
in {
  programs.zsh = {
    plugins = [
      {
        name = "zsh-vi-mode";
        src = pkgs.zsh-vi-mode;
        file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
      }
    ];

    initContent =
      # zsh
      ''
        ZVM_VI_HIGHLIGHT_BACKGROUND=${colors.base02}
        ZVM_VI_HIGHLIGHT_FOREGROUND=${colors.base05}
      '';
  };

  programs.kitty.settings = {
    shell_integration = "no-cursor";
    cursor_shape = "block";
  };
}
