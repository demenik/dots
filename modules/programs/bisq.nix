{
  name = "bisq";

  home = {pkgs, ...}: {
    home.packages = with pkgs; [
      bisq2
    ];
  };
}
