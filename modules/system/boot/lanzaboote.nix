{
  name = "lanzaboote";

  nixos = {
    inputs,
    pkgs,
    lib,
    config,
    ...
  }: let
    cfg = config.boot.lanzaboote;
    esp = config.boot.loader.efi.efiSysMountPoint;

    entryFiles =
      lib.mapAttrs'
      (name: text: lib.nameValuePair "loader/entries/${name}" (pkgs.writeText name text))
      cfg.extraEntries;
    allFiles = cfg.extraFiles // entryFiles;

    manifestRelPath = "loader/.lanzaboote-extra-files";
    manifestLines =
      (map (dest: "F ${dest}") (lib.attrNames allFiles))
      ++ (map (dest: "D ${dest}") (lib.attrNames cfg.extraDirectories));
    manifest = pkgs.writeText "lanzaboote-extra-files-manifest" (lib.concatLines manifestLines);

    copyFileCommands = lib.concatStrings (
      lib.mapAttrsToList (dest: source: ''
        install -D -m 0644 "${source}" "$esp/${dest}"
      '')
      allFiles
    );

    copyDirectoryCommands = lib.concatStrings (
      lib.mapAttrsToList (dest: source: ''
        mkdir -p "$esp/${dest}"
        cp -r --no-preserve=ownership "${source}/." "$esp/${dest}/"
      '')
      cfg.extraDirectories
    );

    wrappedLzbt = pkgs.writeShellApplication {
      name = "lzbt";
      runtimeInputs = [pkgs.coreutils];
      text = ''
        esp="${esp}"
        manifest="$esp/${manifestRelPath}"

        if [ -f "$manifest" ]; then
          while IFS=' ' read -r kind rel; do
            case "$kind" in
            F) [ -n "$rel" ] && rm -f "$esp/$rel" ;;
            D) [ -n "$rel" ] && rm -rf "''${esp:?}/''${rel:?}" ;;
            esac
          done <"$manifest"
        fi

        ${copyFileCommands}
        ${copyDirectoryCommands}
        install -D -m 0644 "${manifest}" "$manifest"

        exec "${realLzbt}/bin/lzbt" "$@"
      '';
    };
    realLzbt = inputs.lanzaboote.packages.${pkgs.stdenv.hostPlatform.system}.lzbt;
  in {
    imports = [
      inputs.lanzaboote.nixosModules.lanzaboote
    ];

    options.boot.lanzaboote = {
      extraFiles = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = {};
        description = ''
          Extra files to copy onto the EFI System Partition, as
          ESP-relative-destination -> source-path. Removed automatically
          (via an on-ESP manifest) once dropped from config and reinstalled.
        '';
      };

      extraDirectories = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = {};
        description = ''
          Extra directories to copy recursively onto the EFI System
          Partition, as ESP-relative-destination -> source-directory.
          Removed automatically (via an on-ESP manifest) once dropped from
          config and reinstalled.
        '';
      };

      extraEntries = lib.mkOption {
        type = lib.types.attrsOf lib.types.lines;
        default = {};
        description = ''
          Extra systemd-boot Type #1 boot entries, as filename -> file
          content, written under loader/entries/. Removed automatically
          once dropped from config and reinstalled.
        '';
      };
    };

    config = {
      environment.systemPackages = with pkgs; [
        sbctl
      ];

      boot.loader.systemd-boot.enable = lib.mkForce false;
      boot.lanzaboote = {
        enable = true;
        pkiBundle = "/var/lib/sbctl";
        package = wrappedLzbt;
      };
    };
  };
}
