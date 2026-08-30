{lib, ...}: {
  name = "multiplexer";

  moduleOptions = with lib; {
    multiplexer.autoAttach.backend = mkOption {
      type = types.nullOr (types.enum ["tmux" "herdr"]);
      default = null;
      description = ''
        Which multiplexer backend, if any, auto-starts/auto-attaches a "main"
        session on interactive shell start. Both backends can be imported at
        once, but only one may own shell startup.
      '';
    };

    programs.tmux.statusIcons.groups = mkOption {
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
  };
}
