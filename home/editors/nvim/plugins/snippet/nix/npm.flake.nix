{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};

      name = "<1>";
      version = "<2>";

      buildInputs = with pkgs; [
        nodejs
      ];
    in {
      packages.default = pkgs.buildNpmPackage {
        inherit name version buildInputs;

        npmDeps = pkgs.importNpmLock {
          npmRoot = ./.;
        };
        inherit (pkgs.importNpmLock) npmConfigHook;

        installPhase = ''
          <0>
        '';
      };

      devShells.default = pkgs.mkShell {
        packages = buildInputs;
      };
    });
}
