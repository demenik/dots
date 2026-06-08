{
  programs.noctalia-shell.settings = {
    idle = {
      enabled = true;
      fadeDuration = 15;

      screenOffTimeout = 600;
      screenOffCommand = "";
      resumeScreenOffCommand = "";

      lockTimeout = 660;
      resumeSuspendCommand = "";
      lockCommand = "";

      suspendTimeout = 0; # = disable
      suspendCommand = "";
      resumeLockCommand = "";

      customCommands = "[]";
    };
  };
}
