{
  name = "nix-portable";

  home = {lib, ...}: {
    home = {
      sessionPath = [
        "$HOME/.local/bin"
      ];

      shellAliases = {
        nix-enter = "nix-portable shell";

        nix = "nix-portable nix";
        nix-shell = lib.mkForce "nix-portable nix-shell --run \"$SHELL\"";
        nix-collect-garbage = "nix-portable nix-collect-garbage";
      };

      sessionVariables = {
        NP_GIT = "git";
      };
    };
  };
}
