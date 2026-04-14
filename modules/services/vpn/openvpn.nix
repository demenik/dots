{
  name = "openvpn";

  secrets = {
    openvpn = {
      description = "Content of .ovpn file";
      requiredBy = "none";
    };
  };

  nixos = {
    pkgs,
    lib,
    config,
    ...
  }: {
    networking.networkmanager = {
      enable = true;
      plugins = with pkgs; [
        networkmanager-openvpn
      ];
    };

    systemd.services.import-openvpn-profile = lib.mkIf (config.sops.secrets ? openvpn) {
      description = "Import OpenVPN profile into NetworkManager";
      wantedBy = ["multi-user.target"];
      after = ["NetworkManager.service"];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = ''
        if ! ${pkgs.networkmanager}/bin/nmcli connection show "openvpn" >/dev/null 2>&1; then
          ${pkgs.networkmanager}/bin/nmcli connection import type openvpn file "${config.sops.secrets.openvpn.path}"
        fi
      '';
    };
  };
}
