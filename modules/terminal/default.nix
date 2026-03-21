{lib, ...}: {
  name = "terminal";
  moduleOptions = with lib; {
    terminal = {
      command = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "kitty";
        description = "Command to start the terminal";
      };

      windowClass = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "kitty";
        description = "Window class of the terminal";
      };
    };
  };

  moduleConfig = {config, ...}: {
    wm.binds = lib.mkIf (config.terminal.command != null) [
      {
        modifiers = ["SUPER"];
        key = "Return";
        exec = config.terminal.command;
      }
    ];
  };

  home = {config, ...}: {
    home.sessionVariables = lib.mkIf (config.terminal.command != null) {
      TERMINAL = config.terminal.command;
    };
  };
}
