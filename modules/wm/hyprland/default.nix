{
  name = "hyprland";

  modules = [
    ../../greeter
    ../wayland.nix
  ];
  moduleConfig = {
    greeter.sessions = ["start-hyprland"];
  };

  nixos = {inputs, ...}: {
    imports = [
      inputs.statusbar.nixosModules.statusbar
    ];

    programs.hyprland.enable = true;
  };
  hostInstructions = ''
    Install hyprland and demenik/statusbar on host system
  '';

  home = {
    pkgs,
    config,
    ...
  }: {
    imports = [
      ./binds.nix
      ./rules.nix
      ./wmRules.nix
      ./theme.nix

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
        misc = {
          disable_hyprland_logo = true;
          focus_on_activate = false;
        };
        xwayland.force_zero_scaling = true;

        input = {
          kb_layout = config.wm.input.keyboard.layout;
          kb_variant = config.wm.input.keyboard.variant;
          repeat_delay = 300;

          touchpad = {
            clickfinger_behavior = config.wm.input.touchpad.tapToClick;
            natural_scroll = config.wm.input.touchpad.naturalScroll;
            disable_while_typing = false;
          };
        };
      };
    };

    services.hyprpolkitagent.enable = true;
  };
}
