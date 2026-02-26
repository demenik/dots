{
  imports = [
    ./plugins
  ];

  programs.zsh.initExtraFirst =
    # zsh
    ''
      if [ -n "$TMUX" ]; then
        function refresh_kitty_env() {
          eval $(tmux show-environment -s KITTY_WINDOW_ID 2>/dev/null)
          eval $(tmux show-environment -s KITTY_PID 2>/dev/null)
        }
        autoload -Uz add-zsh-hook
        add-zsh-hook preexec refresh_kitty_env
      fi

      if [ -n "$PS1" ] && [ -z "$TMUX" ] && [ -z "$SSH_CONNECTION" ]; then
        if tmux has-session -t main 2>/dev/null; then
          exec tmux new-session -t main -s "main-$$" \; new-window
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
        set -ag update-environment " KITTY_WINDOW_ID KITTY_PID"

        bind -n M-Left select-pane -L
        bind -n M-Right select-pane -R
        bind -n M-Up select-pane -U
        bind -n M-Down select-pane -D

        unbind [
        bind v copy-mode
      '';
  };
}
