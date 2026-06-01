{
  name = "vscode";

  home = {pkgs, ...}: {
    home.packages = with pkgs; [
      vscodium-fhs
    ];

    theme.templates.code.enable = true;
  };
}
