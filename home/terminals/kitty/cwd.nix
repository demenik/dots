{pkgs, ...}: let
  # A kitty wrapper, to launch a new kitty window at the same path of the currently focused kitty window.
  # Only works with zsh
  kitty-cwd = pkgs.writeShellApplication {
    name = "kitty-cwd";
    runtimeInputs = with pkgs; [
      hyprland
      jq
      procps
      kitty
    ];
    text =
      # bash
      ''
        active_window="$(hyprctl activewindow -j)"
        class="$(echo "$active_window" | jq -r .class)"
        pid="$(echo "$active_window" | jq -r .pid)"

        leaf_cwd=""

        if [[ "$class" == "kitty" ]]; then
          current_pid="$pid"

          while true; do
            child_pid=$(pgrep -P "$current_pid" -n || true)
            if [[ -z "$child_pid" ]]; then break; fi

            cwd_file="''${XDG_RUNTIME_DIR:-/tmp}/kitty-cwd-$child_pid"
            if [[ -f "$cwd_file" ]]; then
              leaf_cwd=$(cat "$cwd_file")
            fi

            current_pid="$child_pid"
          done
        fi

        target="''${leaf_cwd:-$HOME}"
        kitty --directory "$target"
      '';
  };
in {
  home.packages = [
    kitty-cwd
  ];

  programs = {
    kitty.settings = {
      allow_remote_control = "yes";
      listen_on = "unix:/tmp/kitty-{kitty_pid}";
    };

    zsh.initContent =
      # zsh
      ''
        write_cwd() {
          echo "$PWD" >"''${XDG_RUNTIME_DIR:-/tmp}/kitty-cwd-$$"
        }
        precmd_functions+=(write_cwd)

        cleanup_cwd() {
          rm -f "''${XDG_RUNTIME_DIR:-/tmp}/kitty-cwd-$$"
        }
        zshexit_functions+=(cleanup_cwd)
      '';
  };
}
