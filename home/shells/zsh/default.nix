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

  home.sessionVariables."SHELL" = "${lib.getExe pkgs.zsh}";

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

    initContent = ''
      bindkey -e

      export SHELL="${lib.getExe pkgs.zsh}"
    '';
  };
}
