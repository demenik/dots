{
  name = "openvpn";

  secrets = {
    openvpn = {
      description = "Content of .ovpn file";
      usedBy = "hm";
      required = false;
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

  home = {
    pkgs,
    lib,
    config,
    ...
  }: {
    systemd.user.services.import-openvpn-profile = lib.mkIf (config.sops.secrets ? openvpn) {
      Unit = {
        Description = "Import OpenVPN profile into NetworkManager";
        After = ["network.target"];
      };
      Service = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = pkgs.writeShellScript "import-openvpn" ''
          if ! ${pkgs.networkmanager}/bin/nmcli connection show "openvpn" >/dev/null 2>&1; then
            ${pkgs.networkmanager}/bin/nmcli connection import type openvpn file "${config.sops.secrets.openvpn.path}"
          fi
        '';
        ExecStop = pkgs.writeShellScript "delete-openvpn" ''
          ${pkgs.networkmanager}/bin/nmcli connection delete "openvpn" || true
        '';
      };
      Install.WantedBy = ["default.target"];
    };
  };
}
