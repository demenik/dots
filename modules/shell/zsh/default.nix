{
  name = "zsh";

  modules = [../default.nix];
  moduleConfig = {
    pkgs,
    lib,
    ...
  }: {
    shell.command = lib.getExe pkgs.zsh;
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
      package = pkgs.zsh;
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

          # workaround for nix-shell
          export SHELL="${lib.getExe pkgs.zsh}"
        '';
    };
  };
}
