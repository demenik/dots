{
  name = "hyprland";

  modules = [
    ../../greeter
    ../wayland.nix
  ];
  moduleConfig = {
    pkgs,
    lib,
    ...
  }: {
    greeter.sessions = [
      (lib.getExe' pkgs.hyprland "start-hyprland")
    ];
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
      ./binds.nix
      ./rules.nix
      ./wmRules.nix
      ./theme.nix
    ];

    xdg.portal = {
      extraPortals = [pkgs.xdg-desktop-portal-hyprland];
      config.common = {
        "org.freedesktop.impl.portal.Screencast" = "hyprland";
        "org.freedesktop.impl.portal.Screenshot" = "hyprland";
      };
    };
    xdg.configFile."hypr/xdph.conf".text = ''
      [screencopy]
      allow_token_by_default = true
    '';

    wayland.windowManager.hyprland = {
      enable = true;
      configType = "lua";

      systemd.enable = true;
      xwayland.enable = true;

      settings.config = {
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

    home.file.".local/share/hypr/stubs".source = "${pkgs.hyprland}/share/hypr/stubs";
  };
}
