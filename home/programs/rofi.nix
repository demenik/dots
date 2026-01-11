{
  lib,
  pkgs,
  config,
  ...
}: {
  wayland.windowManager.hyprland.settings = {
    bind = let
      hyprctl = lib.getExe' pkgs.hyprland "hyprctl";
      jq = lib.getExe pkgs.jq;

      rofi-toggle =
        pkgs.writeShellScriptBin "rofi-toggle"
        # bash
        ''
          if pgrep -x "rofi" >/dev/null; then
            pkill -x rofi
            exit 0
          fi

          current_ws=$(${hyprctl} activeworkspace -j | ${jq} '.id')

          ${hyprctl} dispatch workspace 1
          rofi -show drun -show-icons &

          sleep 0.1
          if [ "$current_ws" != "1" ]; then
            ${hyprctl} dispatch workspace "$current_ws"
          fi
        '';
    in [
      "SUPER, Space, exec, ${lib.getExe rofi-toggle}"
    ];

    layerrule = map (rule: "${rule}, match:namespace rofi") [
      "dim_around on"
      "blur on"
      "ignore_alpha on"
      "animation popin 80%"
    ];
  };

  stylix.targets.rofi.enable = false;

  programs.rofi = {
    enable = true;
    extraConfig = {
      modi = "drun,run";
      display-drun = "drun";
      display-run = "run";
    };

    font = "sans-serif 12";

    theme = let
      inherit (config.lib.formats.rasi) mkLiteral;
    in {
      "*" = let
        inherit (config.lib.stylix) colors;
      in {
        bg0 = mkLiteral "#${colors.base00}F2";
        bg1 = mkLiteral "#${colors.base01}";
        bg2 = mkLiteral "#${colors.base02}";
        bg3 = mkLiteral "#${colors.base0E}";
        fg0 = mkLiteral "#${colors.base05}";
        fg1 = mkLiteral "#${colors.base04}";
        fg2 = mkLiteral "#${colors.base03}";
        fg3 = mkLiteral "#${colors.base02}";

        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@fg0";

        margin = mkLiteral "0px";
        padding = mkLiteral "0px";
        spacing = mkLiteral "0px";
      };

      "window" = {
        location = mkLiteral "north";
        y-offset = mkLiteral "calc(50% - 176px)";
        width = 480;
        border-radius = mkLiteral "8px";

        background-color = mkLiteral "@bg0";
      };

      "mainbox".padding = mkLiteral "12px";

      "inputbar" = {
        background-color = mkLiteral "@bg1";
        border-color = mkLiteral "@bg3";

        border = mkLiteral "2px";
        border-radius = mkLiteral "8px";

        padding = mkLiteral "8px 16px";
        spacing = mkLiteral "8px";
        children = map mkLiteral ["prompt" "entry"];
      };

      "prompt".text-color = mkLiteral "@fg2";

      "entry" = {
        placeholder = " Search...";
        placeholder-color = mkLiteral "@fg3";
      };

      "message" = {
        margin = mkLiteral "12px 0 0";
        border-radius = mkLiteral "8px";
        border-color = mkLiteral "@bg2";
        background-color = mkLiteral "@bg2";
      };

      "textbox".padding = mkLiteral "8px 24px";

      "listview" = {
        background-color = mkLiteral "transparent";

        margin = mkLiteral "12px 0 0";
        lines = 8;
        columns = 1;

        fixed-height = true;
      };

      "element" = {
        padding = mkLiteral "8px 16px";
        spacing = mkLiteral "8px";
        border-radius = mkLiteral "8px";
      };

      "element normal active".text-color = mkLiteral "@bg3";
      "element alternate active".text-color = mkLiteral "@bg3";
      "element selected normal, element selected active" = {
        text-color = mkLiteral "@bg0";
        background-color = mkLiteral "@bg3";
      };

      "element-icon" = {
        size = mkLiteral "1em";
        vertical-align = mkLiteral "0.5";
      };

      "element-text".text-color = mkLiteral "inherit";
    };
  };
}
