{pkgs, ...}: {
  home.packages = with pkgs; [
    bisq2
  ];
}
