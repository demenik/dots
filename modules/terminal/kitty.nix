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

  home = {
    programs.kitty = {
      enable = true;
      settings = {
        confirm_os_window_close = 0;
        dynamic_background_opacity = true;
        disable_ligatures = "always";
      };

      shellIntegration.enableZshIntegration = true;
    };

    home.shellAliases = {
      ssh = "kitten ssh";
    };
  };
}
