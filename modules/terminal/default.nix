{lib, ...}: {
  name = "terminal";

  moduleOptions = with lib; {
    terminal = {
      command = mkOption {
        type = types.str;
        example = "kitty";
        description = "Command to start the terminal";
      };

      windowClass = mkOption {
        type = types.str;
        example = "kitty";
        description = "Window class of the terminal";
      };
    };
  };

  home = {config, ...}: {
    home.sessionVariables = {
      TERMINAL = config.terminal.command;
    };
  };
}
