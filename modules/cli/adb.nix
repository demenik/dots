{
  name = "android";
  moduleConfig = {
    wm.windowrules = [
      # Main emulator screen
      {
        matchClass = "Emulator";
        matchTitle = "^Android Emulator";

        floating = true;
        keepAspectRatio = true;
        center = true;
        size = [340 680];
        noInitialFocus = false;
      }
      # Emulator controls
      {
        matchClass = "Emulator";
        matchTitle = "^Emulator$";

        floating = true;
        keepAspectRatio = true;
        size = [43 404];
        noInitialFocus = true;
      }
    ];
  };

  home = {pkgs, ...}: {
    home.packages = with pkgs; [
      android-tools
    ];
  };
}
