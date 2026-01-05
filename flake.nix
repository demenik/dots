{
  description = "demenik's dots";

  nixConfig.experimentalFeatures = ["nix-command" "flakes"];

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl = {
      url = "github:nix-community/nixos-wsl/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim.url = "github:nix-community/nixvim";
    spicetify-nix = {
      url = "github:gerg-l/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mcmojave-cursors = {
      url = "github:vinceliuice/McMojave-cursors";
      flake = false;
    };
    bettersoundcloud = {
      url = "github:demenik/BetterSoundCloud-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    statusbar = {
      url = "github:demenik/statusbar";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.3";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    thorium = {
      url = "github:Rishabh5321/thorium_flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wallpaperengine-gui = {
      url = "github:MikiDevLog/wallpaperengine-gui";
      flake = false;
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    agenix,
    nixos-wsl,
    statusbar,
    lanzaboote,
    ...
  } @ inputs: {
    nixosConfigurations = let
      mkNixConfig = {
        hostName,
        system ? "x86_64-linux",
        user ? "demenik",
        stateVersion,
        dotsDir ? "/home/${user}/dots",
        nixOsModules ? [],
        hmModules ? [],
      }: let
        specialArgs = {inherit inputs stateVersion user dotsDir;};
      in
        nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          modules =
            [
              {
                nixpkgs.hostPlatform = system;
                networking.hostName = hostName;
              }

              home-manager.nixosModules.home-manager
              {
                home-manager = {
                  # useGlobalPkgs = true;
                  backupFileExtension = "bak";

                  users."${user}".imports = hmModules;
                  extraSpecialArgs = specialArgs;
                };
              }
            ]
            ++ nixOsModules;
        };
    in {
      thinkpad = mkNixConfig {
        hostName = "thinkpad";
        stateVersion = "25.05";
        nixOsModules = [
          ./hosts/thinkpad.nix
          ./nixos/full.nix

          statusbar.nixosModules.default
        ];
        hmModules = [
          (import ./home/demenik.nix).full
          ./home/hosts/thinkpad.nix

          agenix.homeManagerModules.default
          ./secrets
        ];
      };

      desktop = mkNixConfig {
        hostName = "desktop";
        stateVersion = "25.11";
        nixOsModules = [
          ./hosts/desktop
          ./nixos/full.nix

          statusbar.nixosModules.default

          lanzaboote.nixosModules.lanzaboote
          ./nixos/optional/lanzaboote.nix
        ];
        hmModules = [
          (import ./home/demenik.nix).full
          ./home/hosts/desktop.nix

          agenix.homeManagerModules.default
          ./secrets
        ];
      };

      wsl = mkNixConfig {
        hostName = "wsl";
        stateVersion = "25.05";
        nixOsModules = [
          ./hosts/wsl.nix
          ./nixos/headless.nix

          nixos-wsl.nixosModules.default
          <nixos-wsl/modules>
        ];
        hmModules = [
          (import ./home/demenik.nix).headless
        ];
      };
    };

    homeConfigurations = let
      mkHomeConfig = {
        system ? "x86_64-linux",
        user ? "demenik",
        stateVersion,
        dotsDir ? "/home/${user}/dots",
        modules ? [],
      }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {inherit system;};
          inherit modules;
          extraSpecialArgs = {inherit inputs stateVersion user dotsDir;};
        };
    in {
      "nix@homelab" = mkHomeConfig rec {
        stateVersion = "25.05";
        user = "nix";
        dotsDir = "/home/${user}/homelab-dots";
        modules = [
          (import ./home/demenik.nix).headless
        ];
      };
      "db56@wsl50" = mkHomeConfig {
        stateVersion = "25.11";
        user = "db56";
        modules = [
          (import ./home/demenik.nix).headless
        ];
      };
    };
  };
}
