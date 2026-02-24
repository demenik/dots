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

  # xdg.configFile."tmux/plugins/tmux-which-key/config.yaml".text = lib.generators.toYAML {} {
  #   command_alias_start_index = 200;
  # };
}
