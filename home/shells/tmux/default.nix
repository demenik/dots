{
  imports = [
    ./plugins
  ];

  programs.zsh.initContent =
    # zsh
    ''
      if [ -n "$PS1" ] && [ -z "$TMUX" ] && [ -z "$SSH_CONNECTION" ]; then
        if tmux has-session -t main 2>/dev/null; then
          exec tmux new-session -t main -s "main-$$"
        else
          exec tmux new-session -s main
        fi
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

        unbind [
        bind v copy-mode
      '';
  };
}
