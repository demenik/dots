{pkgs, ...}: {
  imports = [
    ../global.nix
    ../wayland.nix

    ./binds
    ./hyprlock.nix
    ./dunst.nix
  ];

  home.packages = with pkgs; [
    hyprland
    hyprshade

    xdg-desktop-portal-hyprland
    xdg-desktop-portal-gtk
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    xwayland.enable = true;

    settings = let
      rules = import ./rules.nix;
    in {
      monitor = [",preferred,auto,1"];

      misc.disable_hyprland_logo = true;
      misc.focus_on_activate = true;
      xwayland.force_zero_scaling = true;

      layerrule = rules.layer;
      windowrulev2 = rules.window;
      inherit (rules) workspace;

      input = {
        kb_layout = "de";
        kb_variant = "nodeadkeys";
        repeat_delay = 300;

        touchpad = {
          natural_scroll = true;
          clickfinger_behavior = true;
          disable_while_typing = false;
        };
      };

      general = {
        gaps_in = 5;
        gaps_out = 5;
        border_size = 2;
        layout = "master";
      };

      decoration = {
        rounding = 8;
        blur = {
          size = 4;
          passes = 3;
        };
        dim_around = 0.6;
      };

      animation = import ./animations.nix;
    };
  };

  services.hypridle = import ./hypridle.nix;

  home.sessionVariables = {
    XDG_SESSION_DESKTOP = "Hyprland";
    XDG_CURRENT_DESKTOP = "Hyprland";
  };
}
