{
  name = "herdr";
  modules = [
    ../default.nix
  ];

  imports = [
    ./plugins
  ];

  home = {config, ...}: {
    imports = [
      ./init.nix
      ./theme.nix
      ./wrapper.nix
      ./service.nix
      ./move-pane.nix
    ];

    programs.herdr = {
      enable = true;

      integrations = ["claude" "opencode"];

      settings = {
        onboarding = false;

        keys = {
          prefix = "ctrl+space";

          previous_tab = "shift+left";
          next_tab = "shift+right";
          move_tab_previous = "shift+alt+left";
          move_tab_next = "shift+alt+right";
          indexed.tabs = "ctrl";

          swap_pane_left = ["prefix+shift+h" "ctrl+alt+h" "ctrl+alt+left"];
          swap_pane_down = ["prefix+shift+j" "ctrl+alt+j" "ctrl+alt+down"];
          swap_pane_up = ["prefix+shift+k" "ctrl+alt+k" "ctrl+alt+up"];
          swap_pane_right = ["prefix+shift+l" "ctrl+alt+l" "ctrl+alt+right"];

          split_vertical = "prefix+#";
          split_horizontal = "prefix+-";

          copy_mode = "prefix+v";

          toggle_sidebar = "prefix+e";
          edit_scrollback = "prefix+shift+e";
        };

        ui = {
          mouse_capture = true;
          tab_bar_position = "bottom";
          sound.path = "${../../../../assets/sounds/notification.mp3}";
          toast.delivery = "herdr";
        };

        experimental.kitty_graphics = config.programs.kitty.enable;
      };
    };
  };
}
