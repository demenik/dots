{pkgs, ...}: let
  tmux-notify = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "tmux-notify";
    version = "unstable-2025-01-26";
    src = pkgs.fetchFromGitHub {
      owner = "rickstaa";
      repo = "tmux-notify";
      rev = "b713320af05837c3b44e4d51167ff3062dbeae4b";
      hash = "sha256-wOmq2stWXAFmYrRuIqf9IPATYXJ+OFoYXnJdHUnJQxY=";
    };
    rtpFilePath = "tnotify.tmux";
  };
in {
  home.packages = with pkgs; [
    libnotify
  ];

  programs.tmux.plugins = [
    {
      plugin = tmux-notify;
      extraConfig =
        # tmux
        ''
          set -g @tnotify-verbose 'on'
          set -g @tnotify-prompt-suffixes '$,#,%,>,'
        '';
    }
  ];
}
