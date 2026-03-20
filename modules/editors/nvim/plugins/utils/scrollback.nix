{pkgs, ...}: {
  programs.nixvim = {
    plugins.kitty-scrollback = {
      enable = true;
      package = pkgs.vimPlugins.kitty-scrollback-nvim;
    };
  };

  programs.kitty = {
    shellIntegration.enableZshIntegration = true;

    settings = {
      allow_remote_control = "yes";
      listen_on = "unix:/tmp/kitty-{kitty_pid}";
    };

    keybindings = {
      "kitty_mod+h" = "kitty_scrollback_nvim";
      "kitty_mod+g" = "kitty_scrollback_nvim --config ksb_builtin_last_cmd_output";
    };

    extraConfig = ''
      action_alias kitty_scrollback_nvim kitten ${pkgs.vimPlugins.kitty-scrollback-nvim}/python/kitty_scrollback_nvim.py

      mouse_map ctrl+shift+right press ungrabbed combine : mouse_select_command_output : kitty_scrollback_nvim --config ksb_builtin_last_visited_cmd_output
    '';
  };
}
