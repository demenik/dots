{
  name = "coolercontrol";

  nixos = {
    programs.coolercontrol.enable = true;
  };
  hostInstructions = ''
    Install coolercontrol on host system
  '';

  home = {pkgs, ...}: {
    home.packages = with pkgs; [
      openrgb-with-all-plugins
      coolercontrol.coolercontrol-gui
    ];
  };
}
