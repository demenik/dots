{pkgs, ...}: {
  imports = [
    ./vim-tmux-nav.nix
    ./notify.nix
    ./theme.nix
  ];

  programs.tmux.plugins = with pkgs.tmuxPlugins; [
    sensible # good defaults
    pain-control # binds for panes
    continuum # persistent sessions
    yank
  ];
}
