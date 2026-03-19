{lib, ...}: {
  name = "shells";
  moduleOptions = with lib; {
    shell = {
      command = mkOption {
        type = types.str;
        default = "bash";
      };
    };
  };

  nixos = {config, ...}: {
    environment.variables = {
      SHELL = config.shell.command;
    };
  };

  home = {config, ...}: {
    home.sessionVariables = {
      SHELL = config.shell.command;
    };
  };
}
