{
  name = "uutils";

  nixos = {
    pkgs,
    lib,
    ...
  }: {
    environment.systemPackages = with pkgs; [
      (lib.hiPrio uutils-coreutils-noprefix)
    ];
  };

  home = {
    pkgs,
    lib,
    ...
  }: {
    home.packages = with pkgs; [
      (lib.hiPrio uutils-coreutils-noprefix)
    ];
  };
}
