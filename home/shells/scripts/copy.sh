tmpfile=$(mktemp)
trap 'rm -f "$tmpfile"' EXIT

cat >"$tmpfile"

if [ -t 1 ]; then
  {
    if [ -n "${TMUX:-}" ] || [ "${TERM%%-*}" = "screen" ]; then
      printf "\033Ptmux;\033\033]52;c;"
      base64 <"$tmpfile" | tr -d '\n'
      printf "\007\033\\"
    else
      printf "\033]52;c;"
      base64 <"$tmpfile" | tr -d '\n'
      printf "\007"
    fi
  } >/dev/tty
fi

if command -v wl-copy >/dev/null 2>&1 && [ -n "$WAYLAND_DISPLAY" ]; then
  cat "$tmpfile" | wl-copy
fi

lines=$(wc -l <"$tmpfile")
size=$(wc -c <"$tmpfile")
readable_size=$(numfmt --to=iec-i --suffix=B "$size")

echo "Copied $lines lines ($readable_size)" >&2
