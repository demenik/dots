{
  name = "vlc";

  home = {pkgs, ...}: {
    home.packages = with pkgs; [
      vlc
    ];
  };
}
