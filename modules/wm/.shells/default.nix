{lib, ...}: {
  name = "shells-theme";

  modules = [
    ./.colorScheme.nix
    ./.templates.nix

    ./gtk.nix
    ./qt.nix
  ];

  moduleOptions = with lib; {
    theme = {
      type = mkOption {
        type = types.enum ["colorScheme" "template"];
        default = "colorScheme";
      };
    };
  };
}
