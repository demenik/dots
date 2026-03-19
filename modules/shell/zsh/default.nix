{
  name = "zsh";

  modules = [../default.nix];
  moduleConfig = {
    shell.command = "zsh";
  };

  home = {
    pkgs,
    lib,
    config,
    ...
  }: {
    imports = [
      ./prompt.nix
      ./vi.nix
    ];

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
        lib.mkBefore
        # zsh
        ''
          zmodload zsh/zprof
          bindkey -e
        '';
    };
  };
}
