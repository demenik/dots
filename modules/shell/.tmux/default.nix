{
  name = "tmux";

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

      extraConfig =
        # tmux
        ''
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
