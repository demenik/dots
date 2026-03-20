{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    ags = {
      url = "github:aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ags,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};

      name = "<1>";
      version = "<2>";
      entry = "<3>";

      watchScript = pkgs.writeShellApplication {
        name = "watch";
        runtimeInputs = with pkgs; [
          entr
        ];
        text =
          # bash
          ''
            FILES=$(find . -not \( -path "./node_modules*" -o -path "./@girs*" \) -type f -name "*.ts*")
            echo "$FILES" | entr -crs 'echo "Change detected, restarting..." && ags run ./main.tsx'
          '';
      };

      astalPackages = with ags.packages.${system}; [
        io
        astal4
        <0>
      ];

      buildInputs = with pkgs; [
        gjs
        watchScript
      ];

      extraPackages = with pkgs; [
        libadwaita
        libsoup_3
      ];
    in {
      packages.default = pkgs.stdenv.mkDerivation {
        inherit name version;
        src = ./.;

        nativeBuildInputs = with pkgs; [
          wrapGAppsHook3
          gobject-introspection
          ags.packages.${system}.default
        ];

        buildInputs =
          astalPackages
          ++ buildInputs
          ++ extraPackages;

        installPhase = ''
          mkdir -p "$out"/bin "$out"/share
          cp -r * "$out"/share
          ags bundle "${entry}" "$out"/bin/"${name}" -d "SRC='$out/share'"
        '';
      };

      apps.default = flake-utils.lib.mkApp {
        drv = self.packages.${system}.default;
      };

      devShells.default = pkgs.mkShell {
        buildInputs =
          [
            (ags.packages.${system}.default.override {
              extraPackages = astalPackages ++ extraPackages;
            })
          ]
          ++ buildInputs;
      };
    });
}
