{
  nixos = {
    services.gnome = {
      gnome-keyring.enable = true;
      gnome-online-accounts.enable = true;
      evolution-data-server.enable = true;
    };

    security.pam.services.login.enableGnomeKeyring = true;
  };

  home = {pkgs, ...}: {
    programs.noctalia-shell = {
      plugins.states.weekly-calendar = {
        enabled = true;
        sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
      };

      pluginSettings.weekly-calendar = {};
    };

    home.packages = with pkgs; [
      evolution-data-server
      gnome-calendar
      gnome-control-center
    ];
  };
}
