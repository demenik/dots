{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.programs.tmux.statusIcons;

  semanticColors =
    if config.theme.type == "colorScheme"
    then let
      c = config.colors.withHashtag;
    in {
      black = c.base01;
      red = c.base08;
      green = c.base0B;
      yellow = c.base0A;
      blue = c.base0D;
      magenta = c.base0E;
      cyan = c.base0C;
      white = c.base05;
    }
    else {
      black = "\${THEME[black]}";
      red = "\${THEME[red]}";
      green = "\${THEME[green]}";
      yellow = "\${THEME[yellow]}";
      blue = "\${THEME[blue]}";
      magenta = "\${THEME[magenta]}";
      cyan = "\${THEME[cyan]}";
      white = "\${THEME[white]}";
    };

  mkGroupBadge = variable: states: let
    stateNames = attrNames states;
    mkState = name: let
      state = states.${name};
      color = semanticColors.${state.color};
      blinkOn = optionalString state.blink "#[blink]";
      blinkOff = optionalString state.blink "#[noblink]";
    in
      "#{?#{==:#{${variable}},${name}},"
      + "${blinkOn}#[fg=${color}] ${state.icon}#[fg=default]${blinkOff},";
  in
    concatMapStrings mkState stateNames + concatStrings (genList (_: "}") (length stateNames));

  badge = concatStrings (mapAttrsToList (_: group: mkGroupBadge group.variable group.states) cfg.groups);

  spliceScript = pkgs.writeShellScript "tmux-status-icons-splice" ''
    # Source the dynamic Noctalia theme colors when active
    ${
      optionalString (config.theme.type != "colorScheme")
      # bash
      ''
        theme_colors="$HOME/.config/tmux/tokyo-night-colors.sh"
        [ -f "$theme_colors" ] || exit 0
        # shellcheck disable=SC1090
        source "$theme_colors"
      ''
    }
    badge="${badge}"
    for opt in window-status-format window-status-current-format; do
      current="$(${lib.getExe pkgs.tmux} show-options -gv "$opt")"
      new="$(printf '%s' "$current" | sed "s/#W/#W$badge/")"
      ${lib.getExe pkgs.tmux} set -g "$opt" "$new"
    done
  '';
in {
  options.programs.tmux.statusIcons.groups = mkOption {
    default = {};
    description = ''
      Registry of tmux status icon groups. Each group watches a tmux (user)
      variable and appends an icon to every window tab (after `#W`)
      depending on its current value.
    '';
    type = types.attrsOf (types.submodule {
      options = {
        variable = mkOption {
          type = types.str;
          description = "tmux (user) variable inspected for this group's state, e.g. \"@claude_status\".";
        };
        states = mkOption {
          default = {};
          description = "Map of variable value to the icon rendered when it matches.";
          type = types.attrsOf (types.submodule {
            options = {
              icon = mkOption {
                type = types.str;
                description = "Icon glyph rendered for this state.";
              };
              color = mkOption {
                type = types.enum ["black" "red" "green" "yellow" "blue" "magenta" "cyan" "white"];
                description = "Semantic color the icon is rendered in.";
              };
              blink = mkOption {
                type = types.bool;
                default = false;
                description = "Whether the icon should blink.";
              };
            };
          });
        };
      };
    });
  };

  config = mkIf (cfg.groups != {}) {
    programs.tmux.extraConfig =
      # tmux
      ''
        run-shell ${spliceScript}
      '';
  };
}
