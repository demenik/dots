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

  nixos = {
    programs.zsh = {
      enable = true;
      enableCompletion = false;
    };
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
      enableCompletion = false;
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

          autoload -Uz compinit
          () {
            setopt localoptions extendedglob
            local dump_file="${config.xdg.configHome}/zsh/.zcompdump"
            if [[ -n "$dump_file"(#qN.m-1) ]]; then
              compinit -C -d "$dump_file"
            else
              compinit -d "$dump_file"
            fi
          }

          # Set SHELL in nix shells
          export SHELL=${config.shell.command}
        '';
    };
  };
}
