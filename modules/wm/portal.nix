{
  name = "xdg-portal";

  nixos = {pkgs, ...}: {
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
      ];
      config.common.default = ["gtk"];
    };
  };
}
