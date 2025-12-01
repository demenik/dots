{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    crane.url = "github:ipetkov/crane";
  };

  outputs = {
    nixpkgs,
    fenix,
    crane,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};

      pname = "<1>";
      version = "<2>";

      rust-toolchain = with fenix.packages.${system};
        combine [
          stable.rustc
          stable.cargo
          stable.rust-src
          stable.rust-analyzer
        ];

      craneLib = (crane.mkLib pkgs).overrideToolchain rust-toolchain;

      cargoArtifacts = craneLib.buildDepsOnly {
        pname = "${pname}-deps";
        src = craneLib.cleanCargoSource (craneLib.path ./.);
      };
    in {
      packages.default = craneLib.buildPackage {
        inherit pname version;
        src = craneLib.cleanCargoSource (craneLib.path ./.);
        inherit cargoArtifacts;

        nativeBuildInputs = [rust-toolchain pkgs.lld];
        buildInputs = with pkgs;
          [
            <0>
          ]
          ++ lib.optionals stdenv.isDarwin [
            darwin.apple_sdk.frameworks.Security
          ];

        RUSTFLAGS = "-C link-arg=-fuse-ld=lld";

        meta = with pkgs.lib; {
          description = "<3>";
          license = licenses.mit;
        };
      };

      devShells.default = pkgs.mkShell {
        nativeBuildInputs = with pkgs; [
          lld
        ];

        buildInputs = with pkgs; [
          rust-toolchain
          cargo-watch
          cargo-edit
          cargo-tarpaulin
        ];

        shellHook = ''
          export RUST_SRC_PATH=${fenix.packages.${system}.stable.rust-src}/lib/rustlib/src/rust/library
        '';
      };

      formatter = pkgs.nixpkgs-fmt;
    });
}
