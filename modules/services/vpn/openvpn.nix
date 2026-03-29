{
  name = "openvpn";

  secrets = {
    openvpn = {
      description = "Content of .ovpn file";
      requiredBy = "home";
    };
  };

  nixos = {pkgs, ...}: {
    networking.networkmanager = {
      enable = true;
      plugins = with pkgs; [
        networkmanager-openvpn
      ];
    };
  };
  hostInstructions = ''
    Install networkmanager with networkmanager-openvpn plugin
  '';

  home = {
    pkgs,
    lib,
    config,
    ...
  }: {
    home.activation.setupOpenvpn =
      config.lib.dag.entryAfter ["writeBoundary"]
      # bash
      ''
        if ! ${lib.getExe' pkgs.networkmanager "nmcli"} connection show "openvpn" >/dev/null 2>&1; then
          ${lib.getExe' pkgs.networkmanager "nmcli"} connection import type openvpn file ${config.sops.secrets.openvpn.path}
        fi
      '';
  };
}
