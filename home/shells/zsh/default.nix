{
  lib,
  pkgs,
  config,
  ...
}: {
  imports = [
    ../default.nix
    ./prompt.nix
  ];

  home.sessionVariables."SHELL" = "${lib.getExe pkgs.zsh}";

  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";

    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;

    initContent = ''
      bindkey -e

      export SHELL="${lib.getExe pkgs.zsh}"
    '';
  };
}
