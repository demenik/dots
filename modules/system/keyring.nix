{
  name = "keyring";

  nixos = {pkgs, ...}: {
    services.gnome.gnome-keyring.enable = true;

    security.pam.services = {
      login.enableGnomeKeyring = true;
      greetd.enableGnomeKeyring = true;
    };

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
      ];
      config.common.default = "*";
    };
  };
}
