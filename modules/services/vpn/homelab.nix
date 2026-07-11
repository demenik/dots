{
  name = "homelab-vpn";

  secrets = {
    homelab-vpn = {
      description = "Tailscale Auth Key, starting with 'tskey-auth-...'";
      usedBy = "nixos";
      required = true;
    };
  };

  nixos = {
    pkgs,
    lib,
    config,
    ...
  }: let
    exitNodeAddress = "100.66.79.59";
    authKeyPath = config.sops.secrets.homelab-vpn.path;
  in {
    services.tailscale = {
      enable = true;
      authKeyFile = authKeyPath;

      extraUpFlags = [
        "--reset"
        "--accept-routes"
      ];
    };

    networking.networkmanager = {
      enable = true;

      ensureProfiles.profiles."homelab" = {
        connection = {
          id = "homelab";
          type = "wireguard";
          interface-name = "homelab0";
          autoconnect = false;
        };
        wireguard = {
          private-key = "yAnz5TF+lXXJte14tji3zlMNq+hd2rYUIgJBgB3fB0Y=";
          private-key-flags = 0;
        };
        ipv4 = {
          method = "manual";
          addresses = "10.255.255.2/32";
          never-default = true;
        };
        ipv6.method = "disabled";
      };

      dispatcherScripts = [
        {
          type = "pre-up";
          source = pkgs.writeShellScript "homelab-vpn-pre-up" ''
            ACTION=$2

            if [ "$CONNECTION_ID" = "homelab" ] && [ "$ACTION" = "pre-up" ]; then
              if ! systemctl start homelab-tailscale-exit-node.service; then
                exit 1
              fi
            fi
          '';
        }
        {
          type = "basic";
          source = pkgs.writeShellScript "homelab-vpn-dispatcher" ''
            ACTION=$2

            if [ "$CONNECTION_ID" = "homelab" ] && [ "$ACTION" = "down" ]; then
              systemctl stop homelab-tailscale-exit-node.service
            fi
          '';
        }
      ];
    };

    systemd.services."homelab-tailscale-exit-node" = {
      description = "Toggle homelab tailscale exit node route";
      wantedBy = [];
      after = ["tailscaled.service"];
      bindsTo = ["tailscaled.service"];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;

        ExecStart = "${lib.getExe pkgs.tailscale} set --exit-node=${exitNodeAddress} --exit-node-allow-lan-access=true";

        ExecStop = "${lib.getExe pkgs.tailscale} set --exit-node=";
        ExecStopPost = "-${lib.getExe' pkgs.networkmanager "nmcli"} connection down homelab";
      };
    };
  };
}
