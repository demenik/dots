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
      url = "github:nix-community/lanzaboote/v1.1.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell/legacy-v4";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {flake-modules, ...} @ inputs: let
    hostsDir = ./hosts;
    nixosConfigurations = flake-modules.lib.mkNixosConfigurations {inherit hostsDir inputs;};
    homeConfigurations = flake-modules.lib.mkHomeConfigurations {inherit hostsDir inputs;};

    forEachSystem = f:
      inputs.nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ] (system: f inputs.nixpkgs.legacyPackages.${system});
  in {
    inherit nixosConfigurations homeConfigurations;

    devShells = forEachSystem (pkgs: {
      default = pkgs.mkShell {
        packages = [pkgs.alejandra];
      };
    });

    formatter = forEachSystem (pkgs:
      pkgs.writeShellScriptBin "alejandra" ''
        exec ${pkgs.lib.getExe pkgs.alejandra} -q "$@"
      '');
  };
}
