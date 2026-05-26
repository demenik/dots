{
  name = "nwg-displays";

  home = {pkgs, ...}: {
    home.packages = with pkgs; [
      nwg-displays
    ];
  };
}
