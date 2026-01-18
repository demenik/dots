{
  lib,
  pkgs,
  config,
  ...
}: {
  imports = [
    ../default.nix
    ./prompt.nix
    ./vi.nix
  ];

  home.sessionVariables."SHELL" = lib.getExe pkgs.zsh;

  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";

    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;

    plugins = [
      {
        name = "nix-zsh-completions";
        src = pkgs.nix-zsh-completions;
      }
    ];

    initContent =
      # zsh
      ''
        bindkey -e

        # workaround for nix-shell
        export SHELL="${lib.getExe pkgs.zsh}"
      '';
  };
}
