{
  name = "obsidian";

  moduleConfig = {
    wm.windowrules = [
      {
        matchClass = "obsidian";
        workspace = "1";
      }
    ];
  };

  home = {pkgs, ...}: {
    home.packages = with pkgs; [obsidian];
  };
}
