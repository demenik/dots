{
  pkgs,
  config,
  ...
}: {
  programs.zsh = {
    plugins = [
      {
        name = "zsh-vi-mode";
        src = pkgs.zsh-vi-mode;
        file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
      }
    ];

    initContent = let
      colors = config.lib.stylix.colors.withHashtag;
    in ''
      ZVM_VI_HIGHLIGHT_BACKGROUND=${colors.base02}
      ZVM_VI_HIGHLIGHT_FOREGROUND=${colors.base05}
    '';
  };

  programs.kitty.settings = {
    shell_integration = "no-cursor";
    cursor_shape = "block";
  };
}
