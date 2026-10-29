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
          indexed.tabs = "ctrl";

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
        };

        experimental.kitty_graphics = config.programs.kitty.enable;
      };
    };
  };
}
