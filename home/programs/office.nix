{
  pkgs,
  config,
  ...
}: let
  catppuccin = {
    flavour = "mocha";
    accent = "mauve";
    socHash = "sha256-c7BIwKlwUpD+rLKQQi43mHi2s/hlNkxPE+eX7iWb2vI=";
  };

  themeName = "catppuccin-${catppuccin.flavour}-${catppuccin.accent}";
  themeUrl = "https://raw.githubusercontent.com/catppuccin/libreoffice/main/themes/${catppuccin.flavour}/${catppuccin.accent}/${themeName}.soc";

  themeFile = pkgs.fetchurl {
    url = themeUrl;
    hash = catppuccin.socHash;
  };
in {
  home.packages = with pkgs; [libreoffice];

  xdg.configFile."libreoffice/4/user/config/catppuccin-mocha-mauve.soc" = {
    source = themeFile;
    executable = false;
  };

  # https://github.com/catppuccin/libreoffice/blob/main/scripts/install_theme.sh (edited for nix)
  # home.activation.installCatppuccinLibreofficeTheme = ''
  #   PATH=${pkgs.lib.makeBinPath [pkgs.gawk pkgs.gnugrep pkgs.findutils pkgs.coreutils pkgs.gettext]}

  #   echo "Applying Catppuccin theme to LibreOffice..."

  #   configFile=$(find "${config.xdg.configHome}/libreoffice" -path '*/user/registrymodifications.xcu' -print -quit)

  #   if [[ -z "$configFile" || ! -f "$configFile" ]]; then
  #     echo "LibreOffice registrymodifications.xcu not found. Skipping."
  #     exit 0
  #   fi

  #   echo "Found config at: $configFile"

  #   if grep -q 'oor:name="${themeName}"' "$configFile"; then
  #     echo "Theme '${themeName}' is already installed. Nothing to do."
  #     exit 0
  #   fi

  #   echo "Injecting theme '${themeName}' into $configFile..."

  #   gawk -i inplace -v themePath="${themeFile}" '
  #     BEGIN {
  #       while ((getline line < themePath) > 0) {
  #         themeContent = themeContent line "\n"
  #       }
  #       close(themePath)
  #     }
  #     /<\/oor:items>/ {
  #       printf "%s", themeContent
  #     }
  #     { print }
  #   ' "$configFile"

  #   echo "Successfully applied theme."
  # '';
}
