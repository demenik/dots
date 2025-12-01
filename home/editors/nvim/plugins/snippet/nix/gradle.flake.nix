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
      jdk = pkgs.jdk <0>;
    in {
      devShells.default = pkgs.mkShell {
        buildInputs = [pkgs.gradle jdk];
        JAVA_HOME = jdk.home;
        GRADLE_OPTS = "-Dorg.gradle.java.installations.auto-download=false -Dorg.gradle.java.installations.fromEnv=true";
      };
    });
}
