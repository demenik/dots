{
  name = "keyring";
  modules = [../wm/portal.nix];

  nixos = {
    services.gnome.gnome-keyring.enable = true;

    security.pam.services = {
      login.enableGnomeKeyring = true;
      greetd.enableGnomeKeyring = true;
    };

    xdg.portal.config.common = {
      "org.freedesktop.impl.portal.Secret" = "gnome-keyring";
    };
  };
}
