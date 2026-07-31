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
      pkgs = nixpkgs.legacyPackages.${system};

      pname = "<1>";
      version = "<2>";

      rust-toolchain = with fenix.packages.${system};
        combine [
          stable.rustc
          stable.cargo
          stable.rust-src
          stable.rust-analyzer
        ];

      bevyDeps = with pkgs; [
        pkg-config
        # Audio
        alsa-lib
        # Vulkan
        vulkan-loader
        vulkan-tools
        libudev-zero
        # X11
        xorg.libX11
        xorg.libXcursor
        xorg.libXi
        xorg.libXrandr
        # Wayland
        wayland
        libxkbcommon
        # linker
        lld
      ];
      runtimeLibs = pkgs.lib.makeLibraryPath bevyDeps;

      craneLib = (crane.mkLib pkgs).overrideToolchain rust-toolchain;

      cargoArtifacts = craneLib.buildDepsOnly {
        pname = "${pname}-deps";
        src = craneLib.cleanCargoSource (craneLib.path ./.);
        nativeBuildInputs = with pkgs; [pkg-config];
        buildInputs = bevyDeps;
      };
    in {
      packages.default = craneLib.buildPackage {
        inherit pname version;
        src = craneLib.cleanCargoSource (craneLib.path ./.);
        inherit cargoArtifacts;

        nativeBuildInputs = with pkgs; [
          pkg-config
          rust-toolchain
          lld
          makeWrapper
        ];

        buildInputs = bevyDeps;

        CARGO_PROFILE_RELEASE_LTO = "thin";
        CARGO_PROFILE_RELEASE_CODEGEN_UNITS = 1;
        CARGO_PROFILE_RELEASE_STRIP = true;
        RUSTFLAGS = "-C link-arg=-fuse-ld=lld";

        postInstall = ''
          wrapProgram "$out/bin/${pname}" \
            --prefix LD_LIBRARY_PATH : ${runtimeLibs}
        '';

        meta = with pkgs.lib; {
          description = "<3>";
          license = licenses.mit;
        };
      };

      devShells.default = pkgs.mkShell {
        nativeBuildInputs = with pkgs; [
          pkg-config
          lld
        ];

        packages = with pkgs;
          [
            rust-toolchain
            cargo-watch
            cargo-edit
            cargo-tarpaulin
          ]
          ++ bevyDeps;

        shellHook = ''
          export RUST_SRC_PATH=${fenix.packages.${system}.stable.rust-src}/lib/rustlib/src/rust/library
          export LD_LIBRARY_PATH=${runtimeLibs}:$LD_LIBRARY_PATH
        '';
      };

      formatter = pkgs.nixpkgs-fmt;
    });
}
