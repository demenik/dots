{
  name = "godot";

  home = {
    pkgs,
    config,
    lib,
    ...
  }: {
    home = {
      packages = with pkgs; [godot_4-mono];

      activation.configureGodot = let
        configDir = "${config.xdg.configHome}/godot";

        terminal = config.terminal.command;
        godotNvimWrapper = pkgs.writeShellApplication {
          name = "godot-nvim-wrapper";
          text =
            # bash
            ''
              FILE="$1"
              LINE="$2"
              COL="$3"
              SERVER="./.godothost"

              if [ -S "$SERVER" ]; then
                nvim --server "$SERVER" --remote-send ":e $FILE | call cursor($LINE,$COL)<CR>"
              else
                nohup "${terminal}" -e nvim --listen "$SERVER" "$FILE" "+call cursor($LINE,$COL)" >/dev/null 2>&1 &
                exit 0
              fi
            '';
        };

        colors = config.colors.rgbFloat;
      in
        lib.hm.dag.entryAfter ["writeBoundary"]
        # bash
        ''
          mkdir -p "${configDir}"

          SETTINGS_FILE=$(find "${configDir}" -maxdepth 1 -type f -name 'editor_settings-4*.tres' -print0 | sort -z | tail -z -n 1 | tr -d '\0')
          if [ -z "$SETTINGS_FILE" ]; then
            SETTINGS_FILE="${configDir}/editor_settings-4.6.tres"
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
          update_setting "text_editor/external/exec_path" "\"${lib.getExe godotNvimWrapper}\""
          update_setting "text_editor/external/exec_flags" "\"{file} {line} {col}\""

          # Interface theme
          update_setting "interface/theme/preset" "\"Custom\""
          update_setting "interface/theme/base_color" "Color(${colors.base00}, 1)"
          update_setting "interface/theme/accent_color" "Color(${colors.base0D}, 1)"
          update_setting "interface/theme/contrast" "0.2"
          update_setting "interface/theme/icon_saturation" "0.6"
        '';
    };
  };
}
