{
  name = "nix-portable";

  home = {
    home = {
      sessionPath = [
        "$HOME/.local/bin"
      ];

      shellAliases = {
        nix-enter = "nix-portable shell";

        nix = "nix-portable nix";
        nix-shell = "nix-portable nix-shell --run \"$SHELL\"";
        nix-collect-garbage = "nix-portable nix-collect-garbage";
      };

      sessionVariables = {
        NP_GIT = "git";
      };
    };
  };
}
