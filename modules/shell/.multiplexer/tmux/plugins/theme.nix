{
  pkgs,
  lib,
  config,
  ...
}: let
  c = config.colors.withHashtag;

  patchScript =
    if config.theme.type == "colorScheme"
    then
      # bash
      ''
        # shellcheck disable=SC2016
        sed -i -e '/case $SELECTED_THEME in/a \
        "nix-colors") \
          declare -A THEME=( \
            ["background"]="${c.base00}" \
            ["foreground"]="${c.base05}" \
            ["black"]="${c.base01}" \
            ["blue"]="${c.base0D}" \
            ["cyan"]="${c.base0C}" \
            ["green"]="${c.base0B}" \
            ["magenta"]="${c.base0E}" \
            ["red"]="${c.base08}" \
            ["white"]="${c.base05}" \
            ["yellow"]="${c.base0A}" \
            ["bblack"]="${c.base02}" \
            ["bblue"]="${c.base0D}" \
            ["bcyan"]="${c.base0C}" \
            ["bgreen"]="${c.base0B}" \
            ["bmagenta"]="${c.base0E}" \
            ["bred"]="${c.base09}" \
            ["bwhite"]="${c.base06}" \
            ["byellow"]="${c.base0A}" \
          ) \
          ;;' src/themes.sh

        # shellcheck disable=SC2287
        sed -i 's/THEME\[.ghgreen.\]=.*/THEME["ghgreen"]="${c.base0B}"/' src/themes.sh
        sed -i 's/THEME\[.ghmagenta.\]=.*/THEME["ghmagenta"]="${c.base0E}"/' src/themes.sh
        sed -i 's/THEME\[.ghred.\]=.*/THEME["ghred"]="${c.base08}"/' src/themes.sh
        # shellcheck disable=SC2287
        sed -i 's/THEME\[.ghyellow.\]=.*/THEME["ghyellow"]="${c.base0A}"/' src/themes.sh

        sed -i 's/bg=''${THEME\[blue\]}/bg=${c.accent}/' tokyo-night.tmux
      ''
    else
      # bash
      ''
        sed -i -e '/case $SELECTED_THEME in/a \
        "nix-colors") \
          source ~/.config/tmux/tokyo-night-colors.sh \
          ;;' src/themes.sh

        sed -i 's/THEME\[.ghgreen.\]=.*/THEME["ghgreen"]="''${THEME[ghgreen]}"/' src/themes.sh
        sed -i 's/THEME\[.ghmagenta.\]=.*/THEME["ghmagenta"]="''${THEME[ghmagenta]}"/' src/themes.sh
        # shellcheck disable=SC2287,SC2086
        sed -i 's/THEME\[.ghred.\]=.*/THEME["ghred"]="''${THEME[ghred]}"/' src/themes.sh
        sed -i 's/THEME\[.ghyellow.\]=.*/THEME["ghyellow"]="''${THEME[ghyellow]}"/' src/themes.sh

        sed -i 's/bg=''${THEME\[blue\]}/bg=''${THEME[accent]}/' tokyo-night.tmux
      '';

  tokyo-night-tmux-patched = pkgs.tmuxPlugins.tokyo-night-tmux.overrideAttrs (oldAttrs: {
    postPatch = (oldAttrs.posPatch or "") + patchScript;
  });
in {
  theme.templates.tmux-tokyo-night = {
    enable = true;
    target = "~/.config/tmux/tokyo-night-colors.sh";
    post_hook =
      # bash
      ''
        export TMUX_TMPDIR="/run/user/$(id -u)"
        for server in $(${lib.getExe pkgs.tmux} ls -F '#{socket_path}' 2>/dev/null); do
          ${lib.getExe pkgs.tmux} -S $server source-file ~/.config/tmux/tmux.conf
          ${lib.getExe pkgs.tmux} -S $server source-file ~/.config/tmux/tmux.conf
        done || true
      '';
    text =
      # bash
      ''
        declare -A THEME=(
          ["background"]="default"
          ["foreground"]="{{colors.on_surface.default.hex}}"
          ["black"]="{{colors.surface_container_lowest.default.hex}}"
          ["blue"]="{{colors.primary.default.hex}}"
          ["cyan"]="{{colors.secondary.default.hex}}"
          ["green"]="{{colors.tertiary.default.hex}}"
          ["magenta"]="{{colors.error.default.hex}}"
          ["red"]="{{colors.error.default.hex}}"
          ["white"]="{{colors.on_surface.default.hex}}"
          ["yellow"]="{{colors.primary_container.default.hex}}"
          ["bblack"]="{{colors.surface_variant.default.hex}}"
          ["bblue"]="{{colors.primary.default.hex}}"
          ["bcyan"]="{{colors.secondary.default.hex}}"
          ["bgreen"]="{{colors.tertiary.default.hex}}"
          ["bmagenta"]="{{colors.error.default.hex}}"
          ["bred"]="{{colors.error.default.hex}}"
          ["bwhite"]="{{colors.on_surface.default.hex}}"
          ["byellow"]="{{colors.primary_container.default.hex}}"
          ["ghgreen"]='{{colors.primary.default.hex | blend "#00FF00", 0.6 | set_saturation 80}}'
          ["ghmagenta"]='{{colors.primary.default.hex | blend "#FF00FF", 0.6 | set_saturation 80}}'
          ["ghred"]='{{colors.primary.default.hex | blend "#FF0000", 0.6 | set_saturation 80}}'
          ["ghyellow"]='{{colors.primary.default.hex | blend "#FFFF00", 0.6 | set_saturation 80}}'
          ["accent"]="{{colors.primary.default.hex}}"
        )
      '';
  };
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
