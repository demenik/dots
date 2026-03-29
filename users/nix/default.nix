{
  username = "nix";

  modules = [
    ../../modules/colors.nix

    ../../modules/nix.nix
    ../../modules/shell/zsh
    ../../modules/editors/nvim

    ../../modules/cli/git.nix
    ../../modules/cli/zoxide.nix
    ../../modules/cli/eza.nix
    ../../modules/cli/btop.nix
    ../../modules/cli/bat.nix
    ../../modules/cli/utils.nix
  ];

  moduleConfig = {config, ...}: {
    colors = {
      accent = config.colors.base0E;

      base00 = "1e1e2e";
      base01 = "181825";
      base02 = "313244";
      base03 = "45475a";
      base04 = "585b70";
      base05 = "cdd6f4";
      base06 = "f5e0dc";
      base07 = "b4befe";
      base08 = "f38ba8";
      base09 = "fab387";
      base0A = "f9e2af";
      base0B = "a6e3a1";
      base0C = "94e2d5";
      base0D = "89b4fa";
      base0E = "cba6f7";
      base0F = "f2cdcd";
    };
  };

  homeConfig = {lib, ...}: {
    programs.home-manager.enable = true;

    programs.nixvim = {
      plugins = {
        treesitter.folding = lib.mkForce false;
      };
    };
  };
}
