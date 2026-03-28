{
  name = "niri";

  modules = [
    ../../greeter
    ../wayland.nix

    ../.shells/noctalia
  ];
  moduleConfig = {
    pkgs,
    inputs,
    lib,
    ...
  }: {
    greeter.sessions = [
      (lib.getExe' inputs.niri.packages.${pkgs.stdenv.hostPlatform.system}.niri-stable "niri-session")
    ];
  };

  home = {
    inputs,
    config,
    ...
  }: let
    c = config.colors.withHashtag;
  in {
    imports = [
      inputs.niri.homeModules.niri

      ./binds.nix
      ./wmRules.nix
    ];

    programs.niri = {
      enable = true;
      settings = {
        layout = {
          gaps = 5;

          default-column-width.proportion = 0.5;

          focus-ring = {
            enable = true;
            width = 2;
            active.color = c.accent;
            inactive.color = c.base03;
          };
        };
      };
    };
  };
}
