{lib, ...}: {
  moduleOptions = with lib; {
    programs.noctalia.bootToWindows = {
      enable = mkEnableOption ''
        a session menu entry that reboots once into the Windows firmware boot
        entry via the EFI `BootNext` variable.

        Repurposes noctalia's `userspaceReboot` power option and patches its
        label and icon
      '';

      bootEntryMatch = mkOption {
        type = types.str;
        default = "Windows";
        description = ''
          Case-insensitive extended-regex matched against `efibootmgr` entry
          titles to locate the Windows Boot Manager firmware boot entry.
        '';
      };

      label = mkOption {
        type = types.str;
        default = "Boot into Windows";
        description = "Text shown on the repurposed session menu entry.";
      };

      icon = mkOption {
        type = types.str;
        default = "brand-windows";
        description = "Noctalia (Tabler) icon name for the session menu entry.";
      };
    };
  };

  nixos = {
    pkgs,
    lib,
    config,
    ...
  }: let
    cfg = config.programs.noctalia.bootToWindows;

    bootToWindows = pkgs.writeShellApplication {
      name = "boot-to-windows";
      runtimeInputs = with pkgs; [efibootmgr systemd gnugrep gnused coreutils];
      text =
        # bash
        ''
          match=${lib.escapeShellArg cfg.bootEntryMatch}

          target=$(efibootmgr \
            | grep -iE "^Boot[0-9A-Fa-f]{4}\*?[[:space:]].*$match" \
            | head -n1 \
            | sed -E 's/^Boot([0-9A-Fa-f]{4})\*?.*/\1/' || true)

          if [ -z "''${target:-}" ]; then
            echo "boot-to-windows: no EFI boot entry matching '$match'" >&2
            efibootmgr >&2
            exit 1
          fi

          echo "boot-to-windows: setting BootNext=$target"
          efibootmgr -n "$target" >/dev/null
          exec systemctl reboot
        '';
    };
  in
    lib.mkIf cfg.enable {
      systemd.services.boot-to-windows = {
        description = "Set EFI BootNext to Windows and reboot";
        serviceConfig = {
          Type = "oneshot";
          ExecStart = lib.getExe bootToWindows;
        };
      };

      security.polkit.extraConfig =
        # js
        ''
          polkit.addRule(function (action, subject) {
            if (
              action.id == "org.freedesktop.systemd1.manage-units" &&
              action.lookup("unit") == "boot-to-windows.service" &&
              subject.isInGroup("wheel") &&
              subject.active &&
              subject.local
            ) {
              return polkit.Result.YES;
            }
          });
        '';
    };

  home = {
    pkgs,
    lib,
    config,
    ...
  }: let
    cfg = config.programs.noctalia.bootToWindows;
  in
    lib.mkIf cfg.enable {
      programs.noctalia-shell.wrapper.package = pkgs.noctalia-shell.overrideAttrs (old: {
        postPatch =
          (old.postPatch or "")
          + ''
            for f in Assets/Translations/*.json; do
              sed -i -E 's|("userspace-reboot"[[:space:]]*:[[:space:]]*)"[^"]*"|\1"${cfg.label}"|' "$f"
            done

            sed -i -E '/"userspaceReboot": \{/{n;s|"icon": "[^"]*"|"icon": "${cfg.icon}"|}' \
              Modules/Panels/SessionMenu/SessionMenu.qml
          '';
      });
    };
}
