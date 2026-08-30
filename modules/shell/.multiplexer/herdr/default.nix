{
  name = "herdr";
  modules = [
    ../default.nix
  ];

  home = {config, ...}: {
    imports = [
      ./init.nix
      ./theme.nix
    ];

    programs.herdr = {
      enable = true;

      settings = {
        keys.prefix = "ctrl+space";
        ui.mouse_capture = true;

        experimental.kitty_graphics = config.programs.kitty.enable;
      };
    };
  };
}
