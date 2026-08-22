{lib, ...}: {
  name = "greeter";

  moduleOptions = with lib; {
    greeter.sessions = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "A list of start commands for all installed WMs";
    };
    greeter.sessionName = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Desktop-entry Name= of the primary WM session, as used by session pickers";
    };
  };

  nixos = {
    users = {
      groups.greeter = {};
      users.greeter = {
        isSystemUser = true;
        group = "greeter";
        createHome = false;
      };
    };

    environment.pathsToLink = [
      "/share/wayland-sessions"
      "/share/xsessions"
    ];
  };
}
