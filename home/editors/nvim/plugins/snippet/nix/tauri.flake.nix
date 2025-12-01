{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    nixpkgs,
    rust-overlay,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      overlays = [(import rust-overlay)];
      pkgs = import nixpkgs {inherit system overlays;};

      rustToolchain = pkgs.rust-bin.stable.latest.default.override {
        extensions = ["rust-src"];
      };

      linuxDeps = with pkgs; [
        webkitgtk_4_1
        gtk3
        cairo
        gdk-pixbuf
        glib
        dbus
        openssl
        pkg-config
        librsvg
      ];
    in {
      devShells.default = pkgs.mkShell {
        buildInputs = with pkgs;
          [
            rustToolchain
            rust-analyzer

            nodejs
            cargo-tauri
          ]
          ++ linuxDeps;

        shellHook = ''
          export WEBKIT_DISABLE_COMPOSITING_MODE=1
          export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath linuxDeps}"
        '';
      };
    });
}
