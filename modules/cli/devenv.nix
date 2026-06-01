{
  name = "devenv";

  home = {
    pkgs,
    lib,
    ...
  }: {
    home.packages = with pkgs; [
      devenv
    ];

    programs.zsh.initContent =
      # zsh
      ''
        eval "$(${lib.getExe pkgs.devenv} hook zsh)"
      '';

    ai.mcp.devenv = {
      type = "local";
      command = [(lib.getExe pkgs.devenv) "mcp"];
    };
  };
}
