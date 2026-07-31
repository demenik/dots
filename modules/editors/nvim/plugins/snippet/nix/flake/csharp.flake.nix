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
      pkgs = nixpkgs.legacyPackages.${system};

      dotnet = pkgs.dotnet-sdk_10;
    in {
      devShells.default = pkgs.mkShell {
        DOTNET_ROOT = dotnet;

        packages = with pkgs; [
          dotnet
          <0>
        ];
      };
    });
}
