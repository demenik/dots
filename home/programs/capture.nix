{
  pkgs,
  config,
  ...
}: let
  accent = config.lib.stylix.colors.withHashtag.base0D;
in {
  home.packages = with pkgs; [
    (writeShellApplication {
      name = "screenshot";
      runtimeInputs = [
        grim
        slurp
        wl-clipboard
        jq
        hyprland
        libnotify
      ];
      text =
        # bash
        ''
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
    })
  ];

  wayland.windowManager.hyprland.settings = {
    bind = [
      "SUPER SHIFT, S, exec, screenshot"
    ];
    layerrule = [
      "no_anim on, match:namespace ^(selection)$"
    ];
  };
}
