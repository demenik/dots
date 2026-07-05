{
  name = "android-studio";

  home = {pkgs, ...}: {
    home.packages = with pkgs; [
      android-studio
    ];
  };
}
