{
  pkgs,
  lib,
  ...
}: let
  tmux-which-key-wrapped = pkgs.tmuxPlugins.tmux-which-key.overrideAttrs (old: {
    postInstall =
      (old.postInstall or "")
      + ''
        sed -i '2i export PATH="${pkgs.python3}/bin:$PATH"' $target/plugin.sh.tmux
      '';
  });
in {
  programs.tmux.plugins = [
    {
      plugin = tmux-which-key-wrapped;
      extraConfig =
        # tmux
        ''
          set -g @tmux-which-key-xdg-enable 1
        '';
    }
  ];

  xdg.configFile."tmux/plugins/tmux-which-key/config.yaml".text = ''
    command_alias_start_index: 200

    keybindings:
      prefix_table: Space

    title:
      style: align=centre,bold
      prefix: tmux
      prefix_style: fg=green,align=centre,bold

    position:
      x: R
      y: P

    custom_variables: []
    macros: []

    items:
      - name: Command prompt
        key: ":"
        command: command-prompt
      - separator: true
      - name: New window
        key: c
        command: new-window -c "#{pane_current_path}"
      - name: Kill pane
        key: x
        command: confirm-before -p "kill-pane #P? (y/n)" kill-pane
      - name: Kill window
        key: "&"
        command: confirm-before -p "kill-window #W? (y/n)" kill-window
      - name: Zoom pane
        key: z
        command: resize-pane -Z
      - separator: true
      - name: Next window
        key: n
        command: next-window
      - name: Prev window
        key: p
        command: previous-window
      - name: Choose window
        key: w
        command: choose-tree -Zw
      - name: Choose session
        key: s
        command: choose-tree -Zs
      - separator: true
      - name: Rename window
        key: ","
        command: command-prompt -I "#W" "rename-window %%"
      - name: Rename session
        key: $
        command: command-prompt -I "#S" "rename-session %%"
      - name: Detach
        key: d
        command: detach-client
      - separator: true
      - name: Copy mode
        key: "["
        command: copy-mode
      - name: Paste
        key: "]"
        command: paste-buffer
      - separator: true
      - name: +Panes
        key: P
        menu:
          - name: Break to window
            key: "!"
            command: break-pane
          - name: Next pane
            key: o
            command: select-pane -t :.+
          - name: Last pane
            key: ";"
            command: last-pane
          - name: Swap up
            key: "{"
            command: swap-pane -U
          - name: Swap down
            key: "}"
            command: swap-pane -D
          - name: Show pane numbers
            key: q
            command: display-panes
          - name: Mark pane
            key: m
            command: select-pane -m
          - name: Unmark pane
            key: M
            command: select-pane -M
      - name: +Layouts
        key: L
        menu:
          - name: Next layout
            key: Space
            command: next-layout
          - name: Spread evenly
            key: E
            command: select-layout -E
          - name: Even horizontal
            key: "1"
            command: select-layout even-horizontal
          - name: Even vertical
            key: "2"
            command: select-layout even-vertical
          - name: Main horizontal
            key: "3"
            command: select-layout main-horizontal
          - name: Main vertical
            key: "4"
            command: select-layout main-vertical
          - name: Tiled
            key: "5"
            command: select-layout tiled
      - name: +Buffers
        key: b
        menu:
          - name: Choose buffer
            key: "="
            command: choose-buffer -Z
          - name: List buffers
            key: "#"
            command: list-buffers
      - name: +Client & Misc
        key: C
        menu:
          - name: Find window
            key: f
            command: command-prompt -p find-window "find-window %%"
          - name: Window info
            key: i
            command: display-message
          - name: Show messages
            key: "~"
            command: show-messages
          - name: List keys
            key: "?"
            command: list-keys -N
          - name: Customize
            key: c
            command: customize-mode -Z
          - name: Suspend
            key: z
            command: suspend-client
  '';
}
