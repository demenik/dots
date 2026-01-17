{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./nix.nix
    ./audio.nix
  ];

  programs.dconf.enable = true;

  environment.systemPackages = with pkgs; [
    home-manager
    neovim
    (lib.hiPrio uutils-coreutils-noprefix)
  ];

  services.xserver.xkb = {
    layout = "de";
    variant = "nodeadkeys";
  };
  console.keyMap = "de";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };
  time.timeZone = "Europe/Berlin";

  security = {
    rtkit.enable = true;
    sudo-rs.enable = true;
  };
}
