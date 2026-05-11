{
  name = "uni-ulm-vpn";

  secrets = {
    uni-ulm-vpn = {
      description = ''
        uni-ulm-vpn: |
          USER=<username>
          PASS=<password>
          TOTP_KEY=<totp key>
      '';
      usedBy = "nixos";
      required = true;
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

      ensureProfiles.profiles."Uni-Ulm" = {
        connection = {
          id = "Uni-Ulm";
          type = "wireguard";
          interface-name = "uulm0";
          autoconnect = false;
        };
        wireguard = {
          private-key = "yAnz5TF+lXXJte14tji3zlMNq+hd2rYUIgJBgB3fB0Y=";
          private-key-flags = 0;
        };
        ipv4 = {
          method = "manual";
          addresses = "10.255.255.1/32";
          never-default = true;
        };
        ipv6.method = "disabled";
      };

      dispatcherScripts = [
        {
          type = "pre-up";
          source = pkgs.writeShellScript "uni-ulm-vpn-pre-up" ''
            ACTION=$2

            if [ "$CONNECTION_ID" = "Uni-Ulm" ] && [ "$ACTION" = "pre-up" ]; then
              if ! systemctl start openconnect-uni-ulm-vpn.service; then
                exit 1
              fi
            fi
          '';
        }
        {
          type = "basic";
          source = pkgs.writeShellScript "uni-ulm-vpn-dispatcher" ''
            ACTION=$2

            if [ "$CONNECTION_ID" = "Uni-Ulm" ] && [ "$ACTION" = "down" ]; then
              systemctl stop openconnect-uni-ulm-vpn.service
            fi
          '';
        }
      ];
    };

    systemd.services."openconnect-uni-ulm-vpn" = {
      description = "OpenConnect VPN for Uni-Ulm";
      wantedBy = [];

      path = with pkgs; [
        openconnect
        oath-toolkit
        networkmanager
      ];
      environment = {
        SECRET_PATH = config.sops.secrets.uni-ulm-vpn.path;
      };

      serviceConfig = {
        Type = "forking";
        PIDFile = "/run/openconnect-uni-ulm-vpn.pid";

        ExecStart = lib.getExe (pkgs.writeShellApplication {
          name = "openconnect-uni-ulm-vpn-start";
          runtimeInputs = with pkgs; [
            openconnect
            oath-toolkit
          ];
          text = ''
            # shellcheck disable=SC1090,SC1091
            source "$SECRET_PATH"

            (
              echo "$PASS"
              oathtool --totp -b "$TOTP_KEY"
            ) |
              openconnect \
                --background \
                --pid-file=/run/openconnect-uni-ulm-vpn.pid \
                --protocol=anyconnect \
                --user="$USER" \
                --passwd-on-stdin \
                --useragent="AnyConnect" \
                vpn.uni-ulm.de
          '';
        });
        ExecStopPost = "-${lib.getExe' pkgs.networkmanager "nmcli"} connection down Uni-Ulm";
      };
    };
  };
}
