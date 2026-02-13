{
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = with pkgs; [
    wineWowPackages.full
    winetricks
  ];

  xdg.mime.defaultApplications = {
    "application/x-ms-dos-executable" = "wine.desktop";
    "application/x-msdownload" = "wine.desktop";
    "application/exe" = "wine.desktop";
  };

  boot.binfmt.registrations.wine = {
    recognitionType = "magic";
    magicOrExtension = "MZ";
    interpreter = lib.getExe pkgs.wineWowPackages.full;
  };
}
