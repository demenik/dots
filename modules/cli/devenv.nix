{
  name = "devenv";

  home = {
    pkgs,
    lib,
    ...
  }: let
    devenv-wrapped =
      (pkgs.symlinkJoin {
        name = "devenv-wrapped";
        paths = [pkgs.devenv];
        buildInputs = [pkgs.makeWrapper];
        postBuild = ''
          wrapProgram "$out"/bin/devenv \
            --set DEVENV_TUI false
        '';
      }).overrideAttrs (old: {
        meta = (pkgs.devenv.meta or {}) // {mainProgram = "devenv";};
      });
  in {
    home.packages = [
      devenv-wrapped
    ];

    programs.zsh.initContent =
      # zsh
      ''
        eval "$(${lib.getExe devenv-wrapped} hook zsh)"
      '';

    ai.mcp.devenv = {
      type = "local";
      command = [(lib.getExe devenv-wrapped) "mcp"];
    };
  };
}
