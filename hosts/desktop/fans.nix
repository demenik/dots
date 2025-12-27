{
  user,
  pkgs,
  ...
}: {
  programs.coolercontrol.enable = true;
  home-manager.users."${user}" = {
    home.packages = with pkgs; [
      openrgb-with-all-plugins
      coolercontrol.coolercontrol-gui
    ];
  };
}
