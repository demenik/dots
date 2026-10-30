{lib, ...}: let
  nixpkgsConfig = {
    allowUnfree = true;
  };
in {
  name = "nix";
  moduleOptions = with lib; {
    dots.path = mkOption {
      type = types.str;
      default = "$HOME/dots";
      description = "Path to these dotfiles. Default: ~/dots";
    };
  };

  nixos = {pkgs, ...}: {
    nix = {
      package = pkgs.nix;
      settings = {
        auto-optimise-store = true;
        trusted-users = ["root" "@wheel"];
        experimental-features = ["nix-command" "flakes"];
        warn-dirty = false;
        download-buffer-size = 512 * 1024 * 1024; # 512 MiB
      };
    };

    nixpkgs.config = nixpkgsConfig;

    programs.nh = {
      enable = true;
      clean = {
        enable = true;
        dates = "weekly";
        extraArgs = "--keep 3 --keep-since 14d";
      };
    };
  };

  home = {
    pkgs,
    lib,
    config,
    isStandalone,
    ...
  }: let
    nh-wrapped = pkgs.writeShellApplication {
      name = "nh";
      runtimeInputs = with pkgs; [git nh];
      text = ''
        export NH_FLAKE="${config.dots.path}"

        if git -C "$NH_FLAKE" rev-parse -is-inside-work-tree >/dev/null 2>&1; then
          git -C "$NH_FLAKE" add --intent-to-add .
        fi

        exec "${lib.getExe pkgs.nh}" "$@"
      '';
    };
  in {
    nixpkgs.config = lib.mkIf isStandalone nixpkgsConfig;

    programs.nh = {
      enable = true;
      package = nh-wrapped;

      clean = lib.mkIf isStandalone {
        enable = true;
        dates = "weekly";
        extraArgs = "--keep 3 --keep-since 14d";
      };
    };

    ai.mcp.nixmcp = {
      type = "local";
      command = [(lib.getExe' pkgs.uv "uvx") "--python" (lib.getExe pkgs.python3) "mcp-nixos"];
    };
  };
}
