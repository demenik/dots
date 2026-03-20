{
  description = "demenik's dots";

  nixConfig.experimentalFeatures = ["nix-command" "flakes"];

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-modules = {
      url = "github:demenik/flake-modules";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix = {
      url = "github:gerg-l/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    statusbar = {
      url = "github:demenik/statusbar";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {flake-modules, ...} @ inputs: let
    hostsDir = ./hosts;
    nixosConfigurations = flake-modules.lib.mkNixosConfigurations {inherit hostsDir inputs;};
    homeConfigurations = flake-modules.lib.mkHomeConfigurations {inherit hostsDir inputs;};
  in {
    inherit nixosConfigurations homeConfigurations;
  };
}
