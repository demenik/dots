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
  };

  outputs = {
    nixpkgs,
    home-manager,
    agenix,
    stylix,
    nixos-wsl,
    statusbar,
    ...
  } @ inputs: {
    nixosConfigurations = let
      mkNixConfig = {
        hostName,
        system ? "x86_64-linux",
        user ? "demenik",
        stateVersion ? "25.05",
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
        nixOsModules = [
          ./hosts/thinkpad.nix
          ./nixos/full.nix

          statusbar.nixosModules.default
        ];
        hmModules = [
          ./home/demenik.nix

          agenix.homeManagerModules.default
          ./secrets

          stylix.homeModules.stylix
          ./home/stylix
        ];
      };

      desktop = mkNixConfig {
        hostName = "desktop";
        nixOsModules = [
          ./hosts/desktop.nix
          ./nixos/full.nix

          statusbar.nixosModules.default
        ];
        hmModules = [
          ./home/demenik.nix

          agenix.homeManagerModules.default
          ./secrets

          stylix.homeModules.stylix
          ./home/stylix
        ];
      };

      wsl = mkNixConfig {
        hostName = "wsl";
        nixOsModules = [
          ./hosts/wsl.nix
          ./nixos/headless.nix

          nixos-wsl.nixosModules.default
          <nixos-wsl/modules>
        ];
        hmModules = [
          ./home/headless.nix
        ];
      };
    };

    homeConfigurations = let
      mkHomeConfig = {
        system ? "x86_64-linux",
        user ? "demenik",
        stateVersion ? "25.05",
        dotsDir ? "/home/${user}/dots",
        modules ? [],
      }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {inherit system;};
          inherit modules;
          extraSpecialArgs = {inherit inputs stateVersion user dotsDir;};
        };
    in {
      "nix@homelab" = mkHomeConfig {
        user = "nix";
        dotsDir = "/home/homelab-dots";
        modules = [
          ./home/headless.nix
        ];
      };
      "db56@wsl50" = mkHomeConfig {
        user = "db56";
        modules = [
          ./home/headless.nix
        ];
      };
    };
  };
}
