{
  imports = [
    ./plugins
  ];

  programs.zsh.initContent =
    # zsh
    ''
      if [ -n "$PS1" ] && [ -z "$TMUX" ]; then
        exec tmux new-session -A -s main
      fi
    '';

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

        bind -n M-Left select-pane -L
        bind -n M-Right select-pane -R
        bind -n M-Up select-pane -U
        bind -n M-Down select-pane -D
      '';
  };
}
