{lib, ...}: {
  name = "shells-theme";

  modules = [
    ./.colorScheme.nix
    ./.templates.nix
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
