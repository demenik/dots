{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./cwd.nix
  ];

  programs.kitty = {
    enable = true;
    settings = {
      confirm_os_window_close = 0;
      dynamic_background_opacity = true;
      disable_ligatures = "always";
    };

    shellIntegration.enableZshIntegration = true;
  };

  home.sessionVariables = {
    TERMINAL = lib.getExe pkgs.kitty;
    TERMINAL_CLASS = "kitty";
  };
}
