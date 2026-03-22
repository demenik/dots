{
  name = "screenshot";

  moduleConfig = {
    wm.binds = [
      {
        modifiers = ["SUPER" "SHIFT"];
        key = "s";
        exec = "screenshot";
      }
    ];
  };

  home = {
    pkgs,
    config,
    ...
  }: let
    accent = config.colors.withHashtag.base0E;

    screenshot = pkgs.writeShellApplication {
      name = "screenshot";
      runtimeInputs = with pkgs; [
        grim
        slurp
        wl-clipboard
        jq
        hyprland
        libnotify
      ];
      text = ''
        ACTIVE_WORKSPACES=$(hyprctl monitors -j | jq '[.[] | .activeWorkspace.id]')

        MONITORS=$(hyprctl monitors -j | jq -r '.[] |
          if (.transform % 2 == 1) then
            "\(.x),\(.y) \(.height)x\(.width) \(.name)"
          else
            "\(.x),\(.y) \(.width)x\(.height) \(.name)"
          end
        ')

        WINDOWS=$(hyprctl clients -j | jq -r --argjson active "$ACTIVE_WORKSPACES" '
          .[] | select(.workspace.id as $ws | $active | index($ws) or .pinned?)
          | "\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1]) \(.class)"
        ')

        if SELECTION=$(echo -e "$MONITORS\n$WINDOWS" | slurp -d -c "${accent}" -w 2); then
          grim -g "$SELECTION" - | wl-copy
          notify-send "Screenshot" "was copied to clipboard" -i camera-photo -t 3000
        fi
      '';
    };
  in {
    home.packages = [screenshot];

    wayland.windowManager.hyprland.settings.layerrule = [
      "no_anim on, match:namespace ^(selection)$"
    ];
  };
}
