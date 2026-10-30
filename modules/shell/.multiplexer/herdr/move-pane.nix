{
  pkgs,
  lib,
  ...
}: let
  pickWorkspace = pkgs.writeShellApplication {
    name = "herdr-move-pane-to-workspace";
    runtimeInputs = with pkgs; [fzf jq];
    text = ''
      herdr="''${HERDR_BIN_PATH:-herdr}"
      pane="$HERDR_ACTIVE_PANE_ID"

      choice=$(
        {
          printf 'new\t+ new workspace\n'
          "$herdr" workspace list | jq -r --arg ws "''${HERDR_ACTIVE_WORKSPACE_ID:-}" '
            .result.workspaces[]
            | select(.workspace_id != $ws)
            | "\(.workspace_id)\t\(.number): \(.label)"
          '
        } | fzf --delimiter='\t' --with-nth=2 --reverse --prompt='move pane to > '
      ) || exit 0

      target="''${choice%%$'\t'*}"
      if [ "$target" = new ]; then
        "$herdr" pane move "$pane" --new-workspace --focus
      else
        "$herdr" pane move "$pane" --new-tab --workspace "$target" --focus
      fi
    '';
  };
in {
  programs.herdr.settings.keys.command = [
    {
      key = "prefix+!";
      type = "shell";
      command = ''"''${HERDR_BIN_PATH:-herdr}" pane move "$HERDR_ACTIVE_PANE_ID" --new-tab --focus'';
      description = "move pane to new tab";
    }
    {
      key = "prefix+m";
      type = "popup";
      command = lib.getExe pickWorkspace;
      description = "move pane to workspace";
      width = "50%";
      height = "40%";
    }
  ];
}
