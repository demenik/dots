{
  name = "libreoffice";

  home = {
    pkgs,
    lib,
    ...
  }: let
    catppuccinFlavour = "mocha";
    catppuccinAccent = "mauve";
    themeName = "catppuccin-${catppuccinFlavour}-${catppuccinAccent}";
  in {
    home.packages = with pkgs; [libreoffice];

    xdg.configFile."libreoffice/4/user/config/${themeName}.soc".source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/catppuccin/libreoffice/main/themes/${catppuccinFlavour}/${catppuccinAccent}/${themeName}.soc";
      hash = "sha256-c7BIwKlwUpD+rLKQQi43mHi2s/hlNkxPE+eX7iWb2vI=";
    };

    # https://github.com/catppuccin/libreoffice/blob/main/scripts/install_theme.sh (edited for nix)
    home.activation.installCatppuccinThemeLibreoffice =
      lib.hm.dag.entryAfter ["writeBoundary"]
      # bash
      ''
        LO_CONFIG_DIR="''${XDG_CONFIG_HOME:-$HOME/.config}/libreoffice/4/user"
        FNAME="$LO_CONFIG_DIR/registrymodifications.xcu"
        THEME_FILE="$LO_CONFIG_DIR/config/${themeName}.soc"

        if [ -f "$FNAME" ] && [ -f "$THEME_FILE" ]; then
          if ! grep -q "${themeName}" "$FNAME"; then
            if tail -n1 "$FNAME" | grep -E -q '^</oor:items>$'; then
              cp -p "$FNAME" "$FNAME.$(date -u +"%Y-%m-%dT%H:%M:%SZ")bak"

              HEAD_LINES=$(($(wc -l <"$FNAME") - 1))
              head -n "$HEAD_LINES" "$FNAME" >"$FNAME.tmp"
              cat "$THEME_FILE" >>"$FNAME.tmp"
              tail -n1 "$FNAME" >>"$FNAME.tmp"

              mv "$FNAME.tmp" "$FNAME"
              echo "Injected catpuccin theme into libreoffice"
            else
              echo "Warn: Libreoffice registrymodifications.xcu isn't in the expected format"
              echo "Aborting..."
            fi
          else
            true
          fi
        else
          echo "Info: registrymodifications.xcu or theme file is missing."
        fi
      '';
  };
}
