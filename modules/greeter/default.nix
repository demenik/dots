{lib, ...}: {
  name = "greeter";

  moduleOptions = with lib; {
    greeter.sessions = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "A list of start commands for all installed WMs";
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
  };
}
