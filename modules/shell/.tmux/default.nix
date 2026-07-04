{
  name = "tmux";

  overlays.home = [
    (final: prev: {
      tmuxPlugins =
        prev.tmuxPlugins
        // {
          tmux-notify = prev.tmuxPlugins.mkTmuxPlugin {
            pluginName = "tmux-notify";
            version = "unstable-2025-01-26";
            src = final.fetchFromGitHub {
              owner = "rickstaa";
              repo = "tmux-notify";
              rev = "b713320af05837c3b44e4d51167ff3062dbeae4b";
              hash = "sha256-wOmq2stWXAFmYrRuIqf9IPATYXJ+OFoYXnJdHUnJQxY=";
            };
            rtpFilePath = "tnotify.tmux";
          };
        };
    })
  ];

  home = {
    imports = [
      ./plugins
      ./init.nix
    ];

    programs.tmux = {
      enable = true;

      prefix = "C-space";
      keyMode = "vi";
      mouse = true;

      clock24 = true;
      baseIndex = 1;

      escapeTime = 0;
      terminal = "xterm-256color";

      extraConfig =
        # tmux
        ''
          set -ag terminal-overrides ",xterm-256color:RGB,alacritty:RGB,kitty:RGB"
          setw -g xterm-keys on
          set -g allow-passthrough on

          set -g set-clipboard on
          set -ag update-environment " KITTY_WINDOW_ID KITTY_PID"

          bind -n M-Left select-pane -L
          bind -n M-Right select-pane -R
          bind -n M-Up select-pane -U
          bind -n M-Down select-pane -D

          bind -n S-Left previous-window
          bind -n S-Right next-window

          unbind [
          unbind ]

          bind v copy-mode;
          bind -T copy-mode-vi C-v send-keys -X begin-selection \; send-keys -X rectangle-toggle
          bind -T copy-mode-vi V send-keys -X select-line

          bind -T copy-mode-vi y send-keys -X copy-selection-and-cancel

          unbind p
          bind p paste-buffer -p
        '';
    };
  };
}
