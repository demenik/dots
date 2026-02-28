{lib, ...}: {
  programs.zsh.initContent =
    lib.mkBefore
    # zsh
    ''
      if [ -n "$TMUX" ] && [ -z "$SSH_CONNECTION" ]; then
        function refresh_kitty_env() {
          eval $(tmux show-environment -s KITTY_WINDOW_ID 2>/dev/null)
          eval $(tmux show-environment -s KITTY_PID 2>/dev/null)
        }
        autoload -Uz add-zsh-hook
        add-zsh-hook preexec refresh_kitty_env
      fi

      if [ -n "$PS1" ] && [ -z "$TMUX" ] && [ -z "$SSH_CONNECTION" ]; then
        if tmux has-session -t main 2>/dev/null; then
          exec tmux new-session -t main -s "main-$$"
        else
          exec tmux new-session -s main
        fi
      fi
    '';
}
