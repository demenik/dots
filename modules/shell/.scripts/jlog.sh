MODE=""
SERVICE=""

if [ "$#" -eq 0 ]; then
  # shellcheck disable=SC2016
  SELECTION=$(
    {
      systemctl list-units --all --no-legend --full --no-pager --type=service | awk '{
        svc = ($1 == "●" || $1 == "*") ? $2 : $1;
        print "[System] " svc
      }'
      if systemctl --user is-system-running &>/dev/null; then
        systemctl --user list-units --all --no-legend --full --no-pager --type=service 2>/dev/null | awk '{
          svc = ($1 == "●" || $1 == "*") ? $2 : $1;
          print "[User] " svc
        }'
      fi
    } | fzf \
      --prompt "Select Service: " \
      --preview-window=right:65%:wrap \
      --preview='
        SCOPE={1}
        SVC={2}
        if [ "$SCOPE" = "[User]" ]; then
          SYSTEMD_COLORS=1 systemctl --user status "$SVC" -n 0 --no-pager || true
          echo -e "\n\033[1;34m--- Recent Logs ---\033[0m\n"
          SYSTEMD_COLORS=1 journalctl --user -u "$SVC" -n 20 --no-pager || true
        else
          SYSTEMD_COLORS=1 systemctl status "$SVC" -n 0 --no-pager || true
          echo -e "\n\033[1;34m--- Recent Logs ---\033[0m\n"
          SYSTEMD_COLORS=1 journalctl -u "$SVC" -n 20 --no-pager || true
        fi
      '
  )

  if [ -z "$SELECTION" ]; then
    echo "No service selected. Exiting."
    exit 1
  fi

  read -r TYPE SERVICE <<<"$SELECTION"
  if [ "$TYPE" = "[User]" ]; then
    MODE="--user"
  else
    MODE="--system"
  fi
else
  SERVICE="$1"
  shift

  set +e
  USER_STATE=$(systemctl --user show "$SERVICE" --property=LoadState --value 2>/dev/null)
  SYSTEM_STATE=$(systemctl show "$SERVICE" --property=LoadState --value 2>/dev/null)

  if [ "$USER_STATE" = "loaded" ]; then
    MODE="--user"
  elif [ "$SYSTEM_STATE" = "loaded" ]; then
    MODE="--system"
  else
    echo "Service not found as loaded, defaulting to system: $SERVICE"
    MODE="--system"
  fi
  set -e
fi

set +e
START_TIME=$(systemctl $MODE show "$SERVICE" --property=ActiveEnterTimestamp --value 2>/dev/null)
set -e

if [ -n "$START_TIME" ] && [ "$START_TIME" != "n/a" ]; then
  exec journalctl $MODE -u "$SERVICE" --since="$START_TIME" -f "$@"
else
  exec journalctl $MODE -u "$SERVICE" -b -f "$@"
fi
