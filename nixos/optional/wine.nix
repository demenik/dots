{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    wineWowPackages.full
  ];

  boot.binfmt.registrations.wine = {
    recognitionType = "magic";
    magicOrExtension = "MZ";
    interpreter = pkgs.wineWowPackages.full;
  };
}
