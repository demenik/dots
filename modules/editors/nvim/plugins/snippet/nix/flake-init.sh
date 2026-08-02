# Scaffold a flake.nix from a template, then, if it has placeholders to fill
# in, open it in Neovim and expand the matching LuaSnip snippet directly
# (bypassing cmp, since there is no completion menu to drive from a script).

declare -A TRIGGER_BY_NAME=(
  @triggerByName@
)

declare -A HAS_PLACEHOLDERS=(
  @hasPlaceholdersByTrigger@
)

templates_dir="@templatesDir@"

usage() {
  cat <<EOF
Usage: flake-init [NAME]

Scaffold a flake.nix (plus .envrc and .gitignore) from a template. If the
template has placeholders, Neovim opens on the file to fill them in.

Available templates:
EOF
  printf '  %s\n' "${!TRIGGER_BY_NAME[@]}" | sort
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

name="${1:-}"

if [[ -z "$name" ]]; then
  name=$(printf '%s\n' "${!TRIGGER_BY_NAME[@]}" | sort | fzf --prompt="Flake template> ") || {
    echo "flake-init: no template selected" >&2
    exit 1
  }
fi

if [[ -z "${TRIGGER_BY_NAME[$name]:-}" ]]; then
  echo "flake-init: unknown template '$name'" >&2
  usage >&2
  exit 1
fi

trigger="${TRIGGER_BY_NAME[$name]}"

confirm_overwrite() {
  local path=$1
  if [[ ! -e "$path" ]]; then
    return 0
  fi
  local reply
  read -r -p "$path already exists. Overwrite? [y/N] " reply
  [[ "$reply" =~ ^[Yy]$ ]]
}

if ! confirm_overwrite flake.nix; then
  echo "Aborted." >&2
  exit 1
fi

if confirm_overwrite .envrc; then
  printf 'use flake\n' >.envrc
  echo "Wrote .envrc"
fi

if [[ ! -e .gitignore ]]; then
  printf '.direnv\n' >.gitignore
  echo "Created .gitignore"
elif ! grep -qxF '.direnv' .gitignore; then
  printf '.direnv\n' >>.gitignore
  echo "Appended .direnv to .gitignore"
fi

if [[ "${HAS_PLACEHOLDERS[$trigger]}" != "1" ]]; then
  cp "$templates_dir/$trigger" flake.nix
  echo "Wrote flake.nix (no placeholders to fill in)"
  exit 0
fi

if ! command -v nvim >/dev/null 2>&1; then
  echo "flake-init: nvim not found on PATH; wrote an empty flake.nix instead" >&2
  : >flake.nix
  exit 1
fi

# Truncate first: if flake.nix already existed and was just confirmed for
# overwrite, Neovim must open it empty so the snippet expands into a blank
# buffer rather than being inserted into the old content.
: >flake.nix

lua_cmd=$(
  cat <<LUA
lua vim.schedule(function()
  local ls = require('luasnip')
  local target
  for _, snip in ipairs(ls.get_snippets('nix')) do
    if snip.trigger == [==[${trigger}]==] then
      target = snip
      break
    end
  end
  if target then
    ls.snip_expand(target)
  else
    vim.notify('flake-init: snippet not found in nvim config: ' .. [==[${trigger}]==], vim.log.levels.ERROR)
  end
end)
LUA
)

exec nvim -c "$lua_cmd" flake.nix
