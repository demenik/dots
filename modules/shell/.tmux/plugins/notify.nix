{pkgs, ...}: {
  home.packages = with pkgs; [
    libnotify
  ];

  programs.tmux.plugins = [
    {
      plugin = pkgs.tmuxPlugins.tmux-notify;
      extraConfig =
        # tmux
        ''
          set -g @tnotify-verbose 'on'
          set -g @tnotify-prompt-suffixes '$,#,%,>,'
        '';
    }
  ];
}
