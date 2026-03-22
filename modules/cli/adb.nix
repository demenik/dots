{
  name = "android";

  home = {pkgs, ...}: {
    home.packages = with pkgs; [
      android-tools
    ];
  };
}
