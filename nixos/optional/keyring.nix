{
  services = {
    gnome.gnome-keyring.enable = true;
    dbus.enable = true;
  };
  security.pam.services.login.enableGnomeKeyring = true;
}
