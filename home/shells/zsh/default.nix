{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./prompt.nix
    ./aliases.nix
    ./scripts.nix
  ];

  home.sessionVariables."SHELL" = "${lib.getExe pkgs.zsh}";

  programs.zsh = {
    enable = true;

    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;

    initContent = ''
      bindkey -e

      export SHELL="${lib.getExe pkgs.zsh}"
    '';
  };
}
