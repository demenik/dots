{
  name = "craftapps";

  home = {inputs, ...}: {
    imports = [
      inputs.craftapps.homeManagerModules.default
    ];

    programs.craftapps = {
      enable = true;
      apps = {
        photocraft.enable = true;
        vectorcraft.enable = true;
      };
    };
  };
}
