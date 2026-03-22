{
  pkgs,
  config,
  ...
}: let
  c = config.colors.withHashtag;

  tokyo-night-tmux-patched = pkgs.tmuxPlugins.tokyo-night-tmux.overrideAttrs (oldAttrs: {
    postPatch =
      (oldAttrs.posPatch or "")
      # bash
      + ''
        sed -i -e '/case $SELECTED_THEME in/a \
        "nix-colors") \
          declare -A THEME=( \
            ["background"]="${c.base00}" \
            ["foreground"]="${c.base05}" \
            ["black"]="${c.base03}" \
            ["blue"]="${c.base0D}" \
            ["cyan"]="${c.base0C}" \
            ["green"]="${c.base0B}" \
            ["magenta"]="${c.base0E}" \
            ["red"]="${c.base08}" \
            ["white"]="${c.base05}" \
            ["yellow"]="${c.base0A}" \
            ["bblack"]="${c.base04}" \
            ["bblue"]="${c.base0D}" \
            ["bcyan"]="${c.base0C}" \
            ["bgreen"]="${c.base0B}" \
            ["bmagenta"]="${c.base0E}" \
            ["bred"]="${c.base09}" \
            ["bwhite"]="${c.base06}" \
            ["byellow"]="${c.base0A}" \
          ) \
          ;;' src/themes.sh

        sed -i 's/THEME\[.ghgreen.\]=.*/THEME["ghgreen"]="${c.base0B}"/' src/themes.sh
        sed -i 's/THEME\[.ghmagenta.\]=.*/THEME["ghmagenta"]="${c.base0E}"/' src/themes.sh
        sed -i 's/THEME\[.ghred.\]=.*/THEME["ghred"]="${c.base08}"/' src/themes.sh
        sed -i 's/THEME\[.ghyellow.\]=.*/THEME["ghyellow"]="${c.base0A}"/' src/themes.sh

        sed -i 's/bg=''${THEME\[blue\]}/bg=${c.accent}/' tokyo-night.tmux
      '';
  });
in {
  programs.tmux.plugins = [
    {
      plugin = tokyo-night-tmux-patched;
      extraConfig =
        # tmux
        ''
          set -g @tokyo-night-tmux_theme "nix-colors"
          set -g @tokyo-night-tmux_transparent 1

          set -g @tokyo-night-tmux_window_id_style dsquare
          set -g @tokyo-night-tmux_pane_id_style hsquare

          set -g @tokyo-night-tmux_window_tidy_icons 0

          set -g @tokyo-night-tmux_show_datetime 0

          set -g @tokyo-night-tmux_show_path 1
          set -g @tokyo-night-tmux_path_format relative

          set -g @tokyo-night-tmux_show_wbg 1
        '';
    }
  ];
}
