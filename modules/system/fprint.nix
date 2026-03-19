{lib, ...}: {
  name = "fprint";
  moduleOptions = with lib; {
    fprint.driver = mkOption {
      type = types.nullOr types.package;
      default = null;
      description = "Tod driver to use";
    };
  };

  nixos = {
    pkgs,
    config,
    ...
  }: {
    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "libfprint-2-tod1-goodix-550a"
      ];

    services.fprintd = {
      enable = true;
      tod.enable = true;
      tod.driver =
        if config.fprint.driver != null
        then config.fprint.driver
        else pkgs.libfprint-2-tod1-goodix-550a;
    };
  };
}
