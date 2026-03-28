{
  name = "statusbar";

  nixos = {inputs, ...}: {
    imports = [inputs.statusbar.nixosModules.statusbar];
  };
  hostInstructions = ''
    Install github.com/demenik/statusbar on host
  '';
}
