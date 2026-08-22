{pkgs, ...}: {
  imports = [
    ./vim-tmux-nav.nix
    ./notify.nix
    ./theme.nix
    ./status-icons.nix
  ];

  programs.tmux.plugins = with pkgs.tmuxPlugins; [
    sensible # good defaults
    pain-control # binds for panes
    continuum # persistent sessions
    yank
  ];
}
