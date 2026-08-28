{
  name = "caelestia";

  nixos = {config, ...}: {
    assertions = [
      {
        assertion = config.programs.hyprland.enable;
        message = "Caelestia shell requires Hyprland";
      }
    ];
  };

  home = {inputs, ...}: {
    imports = [
      inputs.caelestia-shell.homeManagerModules.default
    ];

    programs.caelestia = {
      enable = true;
      cli.enable = true;
    };
  };
}
