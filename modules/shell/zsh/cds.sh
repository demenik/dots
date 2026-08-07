cds() {
  local old="$PWD"
  z "$@" || return
  local new="$PWD"
  [[ -n "$TMUX" && "$old" != "$new" ]] || return 0

  local self="${TMUX_PANE:-}"
  local quoted
  printf -v quoted '%q' "$new"

  tmux list-panes -a -F '#{pane_id}|#{pane_current_path}|#{pane_current_command}' |
    while IFS='|' read -r pane pane_path cmd; do
      [[ "$pane_path" == "$old" && "$pane" != "$self" ]] || continue
      case "$cmd" in
        zsh | bash | fish) tmux send-keys -t "$pane" "cd -- $quoted" Enter ;;
      esac
    done
}
