cds() {
  local old="$PWD"
  z "$@" || return
  local new="$PWD"
  [[ "$old" != "$new" ]] || return 0

  local quoted
  printf -v quoted '%q' "$new"

  if [[ -n "$TMUX" ]]; then
    local self="${TMUX_PANE:-}"

    tmux list-panes -a -F '#{pane_id}|#{pane_current_path}|#{pane_current_command}' |
      while IFS='|' read -r pane pane_path cmd; do
        [[ "$pane_path" == "$old" && "$pane" != "$self" ]] || continue
        case "$cmd" in
        zsh | bash | fish) tmux send-keys -t "$pane" "cd -- $quoted" Enter ;;
        esac
      done
  elif [[ -n "$HERDR_PANE_ID" ]]; then
    herdr pane list 2>/dev/null |
      jq -r --arg old "$old" --arg self "$HERDR_PANE_ID" \
        '.panes[] | select(.cwd == $old and .pane_id != $self and .agent == null) | .pane_id' |
      while IFS= read -r pane; do
        herdr pane send-text "$pane" "cd -- $quoted"
        herdr pane send-keys "$pane" enter
      done
  fi
}
