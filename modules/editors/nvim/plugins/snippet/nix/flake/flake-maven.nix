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
      jdk = pkgs.jdk<0>;
    in {
      devShells.default = pkgs.mkShell {
        nativeBuildInputs = [pkgs.maven jdk];
        JAVA_HOME = jdk.home;
      };
    });
}
