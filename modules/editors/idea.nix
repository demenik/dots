{
  name = "intellij";

  moduleConfig = {
    wm.windowrules = [
      {
        matchClass = "jetbrains-idea";
        matchTitle = "splash";

        floating = true;
        center = true;
        noInitialFocus = true;
      }
    ];
  };

  home = {pkgs, ...}: {
    home.packages = with pkgs; [
      jetbrains.idea-oss
    ];
  };
}
