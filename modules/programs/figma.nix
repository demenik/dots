{
  name = "figma";

  home = {pkgs, ...}: {
    home.packages = with pkgs; [
      figma-linux
    ];
  };
}
