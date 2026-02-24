{pkgs, ...}: {
  imports = [
    ./which-key.nix
    ./vim-tmux-nav.nix
    ./notify.nix
  ];

  programs.tmux.plugins = with pkgs.tmuxPlugins; [
    {
      plugin = catppuccin;
      extraConfig =
        # tmux
        ''
          set -g @catppuccin_flavor 'mocha'
          set -g @catppuccin_window_tabs_enabled on
        '';
    }

    sensible # good defaults
    pain-control # binds for panes
    continuum # persistent sessions
    yank
  ];
}
