{
  name = "herdr";
  modules = [
    ../default.nix
  ];

  home = {config, ...}: {
    imports = [
      ./init.nix
      ./theme.nix
    ];

    programs.herdr = {
      enable = true;

      settings = {
        keys = {
          prefix = "ctrl+space";

          focus_pane_left = "alt+left";
          focus_pane_down = "alt+down";
          focus_pane_up = "alt+up";
          focus_pane_right = "alt+right";

          previous_tab = "shift+left";
          next_tab = "shift+right";
          indexed.tabs = "ctrl";

          copy_mode = "prefix+v";
        };

        ui.mouse_capture = true;

        experimental.kitty_graphics = config.programs.kitty.enable;
      };
    };
  };
}
