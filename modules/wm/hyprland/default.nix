{
  name = "hyprland";

  modules = [
    ../../greeter
    ../wayland.nix
  ];
  moduleConfig = {
    greeter.sessions = ["start-hyprland"];
  };

  nixos = {
    programs.hyprland.enable = true;
  };
  hostInstructions = ''
    Install hyprland on host system
  '';

  home = {
    pkgs,
    config,
    ...
  }: {
    imports = [
      ./rules.nix
      ./wmRules.nix

      ./hyprlock.nix
      ./hypridle.nix
    ];

    home.packages = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = true;
      xwayland.enable = true;

      settings = {
        monitorv2 =
          map (m: {
            inherit (m) output mode position scale transform bitdepth vrr;
            cm = m.colorMode;
          })
          config.wm.monitors;

        misc = {
          disable_hyprland_logo = true;
          focus_on_activate = false;
        };
        xwayland.force_zero_scaling = true;

        input = {
          kb_layout = config.wm.input.keyboard.layout;
          kb_variant = config.wm.input.keyboard.variant;

          touchpad = {
            clickfinger_behavior = config.wm.input.touchpad.tapToClick;
            natural_scroll = config.wm.input.touchpad.naturalScroll;
            disable_while_typing = false;
          };
        };

        general = {
          layout = "master";

          gaps_in = 5;
          gaps_out = 5;
          border_size = 2;
        };
      };
    };

    services.hyprpolkitagent.enable = true;
  };
}
