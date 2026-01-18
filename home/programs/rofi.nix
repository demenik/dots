{
  lib,
  pkgs,
  config,
  ...
}: {
  wayland.windowManager.hyprland.settings = {
    bind = let
      rofi-toggle = pkgs.writeShellApplication {
        name = "rofi-toggle";
        runtimeInputs = with pkgs; [
          procps
          jq
          hyprland
          rofi
        ];
        text =
          # bash
          ''
            if pgrep -x "rofi" >/dev/null; then
              pkill -x rofi
              exit 0
            fi

            rofi -show drun -show-icons -monitor HDMI-A-1
          '';
      };
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
        colors = config.lib.stylix.colors.withHashtag;
      in {
        bg0 = mkLiteral "${colors.base00}F2";
        bg1 = mkLiteral colors.base01;
        bg2 = mkLiteral colors.base02;
        bg3 = mkLiteral colors.base0D;
        fg0 = mkLiteral colors.base05;
        fg1 = mkLiteral colors.base04;
        fg2 = mkLiteral colors.base03;
        fg3 = mkLiteral colors.base02;

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
