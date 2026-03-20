{
  name = "zip";

  home = {pkgs, ...}: {
    home.packages = with pkgs; [
      zip
      unzip
    ];
  };
}
