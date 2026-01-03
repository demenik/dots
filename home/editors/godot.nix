{
  pkgs,
  config,
  lib,
  ...
}: {
  home = {
    packages = with pkgs; [
      godot
    ];

    activation.configureGodot = let
      configDir = "${config.xdg.configHome}/godot";
      # This script requires $TERMINAL to be set to your default terminal
      godotNvimWrapper =
        pkgs.writeShellScript "godot-nvim-wrapper"
        # bash
        ''
          FILE="$1"
          LINE="$2"
          COL="$3"
          SERVER="./.godothost"

          if [ -S "$SERVER" ]; then
            $(which nvim) --server "$SERVER" --remote-send ":e $FILE | call cursor($LINE,$COL)<CR>"
          else
            nohup "$(which "$TERMINAL")" -e "$(which nvim)" --listen "$SERVER" "$FILE" "+call cursor($LINE,$COL)" >/dev/null 2>&1 &
            exit 0
          fi
        '';
    in
      lib.hm.dag.entryAfter ["writeBoundary"]
      # bash
      ''
        mkdir -p "${configDir}"

        SETTINGS_FILE=$(find "${configDir}" -maxdepth 1 -type f -name 'editor_settings-4*.tres' -print0 | sort -z | tail -z -n 1 | tr -d '\0')
        if [ -z "$SETTINGS_FILE" ]; then
          SETTINGS_FILE="${configDir}/editor_settings-4.5.tres"
          echo "No existing Godot settings file found. Creating at $SETTINGS_FILE"
          echo -e '[gd_resource type="EditorSettings" format=3]\n' >"$SETTINGS_FILE"
          echo '[resource]' >>"$SETTINGS_FILE"
        else
          echo "Found Godot settings file at $SETTINGS_FILE"
        fi

        update_setting() {
          local key="$1"
          local value="$2"

          if grep -q "^$key =" "$SETTINGS_FILE"; then
            sed "s#^$key =.*#$key = $value#" "$SETTINGS_FILE" >"$SETTINGS_FILE.tmp" && mv "$SETTINGS_FILE.tmp" "$SETTINGS_FILE"
          else
            if grep -q '\[resource\]' "$SETTINGS_FILE"; then
              echo "$key = $value" >>"$SETTINGS_FILE"
            fi
          fi
        }

        # External editor (nvim)
        update_setting "text_editor/external/use_external_editor" "true"
        update_setting "text_editor/external/exec_path" "\"${godotNvimWrapper}\""
        update_setting "text_editor/external/exec_flags" "\"{file} {line} {col}\""

        # Catppuccin Mocha interface theme
        update_setting "interface/theme/preset" "\"Custom\""
        # Base Color: #1e1e2e
        update_setting "interface/theme/base_color" "Color(0.118, 0.118, 0.18, 1)"
        # Accent Color: #cba6f7
        update_setting "interface/theme/accent_color" "Color(0.796, 0.651, 0.969, 1)"
        # Contrast: 0.2
        update_setting "interface/theme/contrast" "0.2"
        # Icon Saturation: 0.6
        update_setting "interface/theme/icon_saturation" "0.6"

        # Catppuccin Mocha syntax theme
        update_setting "text_editor/theme/highlighting/syntax_theme" "\"Catppuccin Mocha\""

        # https://github.com/NixOS/nixpkgs/issues/454608#issuecomment-3450986999
        update_setting "network/tls/editor_tls_certificates" "\"/etc/ssl/certs/ca-certificates.crt\""
      '';
  };

  xdg.configFile."godot/text_editor_themes/Catppuccin Mocha.tet".source =
    pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "godot";
      rev = "d8b72b679078f0103a5e5c1ef793c1d698a563b1";
      hash = "sha256-Og69rMEsygVYpWVGvJGsCydQzRC9BXBQxyrJ4kfdUEo=";
    }
    + "/themes/Catppuccin Mocha.tet";
}
