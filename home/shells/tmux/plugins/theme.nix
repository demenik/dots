{pkgs, ...}: let
  tokyo-night-tmux-patched = pkgs.tmuxPlugins.tokyo-night-tmux.overrideAttrs (oldAttrs: {
    patches =
      (oldAttrs.patches or [])
      ++ [
        ./tokyo-night-catppuccin.patch
      ];
  });
in {
  programs.tmux.plugins = [
    {
      plugin = tokyo-night-tmux-patched;
      extraConfig =
        # tmux
        ''
          set -g @tokyo-night-tmux_theme "catppuccin-mocha"
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
