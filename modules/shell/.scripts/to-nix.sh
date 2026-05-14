INPUT=$(cat)

if [ -z "$INPUT" ]; then
  echo "Error: no input provided on stdin" >&2
  exit 1
fi

TMPFILES=()
cleanup() {
  rm -f "${TMPFILES[@]}"
}
trap cleanup EXIT

TMP_IN=$(mktemp)
TMPFILES+=("$TMP_IN")
printf "%s" "$INPUT" >"$TMP_IN"

try_eval() {
  local expr="$1"
  nix-instantiate --eval --strict --expr "$expr" 2>/dev/null
}

format() {
  local unformatted="$1"
  echo "$unformatted" | alejandra --quiet
}

if OUTPUT=$(try_eval "builtins.fromJSON (builtins.readFile $TMP_IN)"); then
  format "$OUTPUT"
  exit 0
fi

if OUTPUT=$(try_eval "builtins.fromTOML (builtins.readFile $TMP_IN)"); then
  format "$OUTPUT"
  exit 0
fi

if JSON=$(echo "$INPUT" | yj -yj 2>/dev/null); then
  TMP_YAML=$(mktemp)
  TMPFILES+=("$TMP_YAML")
  printf "%s" "$JSON" >"$TMP_YAML"

  if OUTPUT=$(try_eval "builtins.fromJSON (builtins.readFile $TMP_YAML)"); then
    format "$OUTPUT"
    exit 0
  fi
fi

echo "Error: Could not automatically detect or parse input as JSON, TOML, or YAML." >&2
cleanup
exit 1
