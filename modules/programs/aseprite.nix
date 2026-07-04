{
  name = "asperite";

  overlays.home = [
    (final: prev: let
      mkAsepriteExtension = name: archive:
        final.runCommand "aseprite-ext-${name}" {
          nativeBuildInputs = [final.unzip];
        } ''
          mkdir -p "$out"

          tmpdir=$(mktemp -d)
          unzip "${archive}" -d "$tmpdir"

          shopt -s dotglob
          entries=("$tmpdir"/*)
          if [ ''${#entries[@]} -eq 1 ] && [ -d "''${entries[0]}" ]; then
            mv "''${entries[0]}"/* "$out/"
          else
            mv "$tmpdir"/* "$out/"
          fi
        '';
    in {
      aseprite-catppuccin-theme = mkAsepriteExtension "catppuccin-mocha" (final.fetchurl {
        url = "https://github.com/catppuccin/aseprite/releases/download/v1.2.1/catppuccin-theme-mocha.aseprite-extension";
        hash = "sha256-embvGNZaGGim9JpWaigbIkt5NxHXpSI+2AaNkgKwMK4=";
      });
    })
  ];

  home = {pkgs, ...}: {
    home.packages = [pkgs.aseprite];

    xdg.configFile = {
      "aseprite/extensions/catppuccin-mocha" = {
        source = pkgs.aseprite-catppuccin-theme;
        recursive = true;
      };
    };
  };
}
