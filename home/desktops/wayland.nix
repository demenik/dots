{pkgs, ...}: {
  imports = [
    ./global.nix
  ];

  home = {
    packages = with pkgs; [
      wl-clipboard
    ];

    sessionVariables = {
      GDK_BACKEND = "wayland";
      QT_QPA_PLATFORM = "wayland";
      CLUTTER_BACKEND = "wayland";
      SDL_VIDEODRIVER = "wayland";
      XDG_SESSION_TYPE = "wayland";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    };
  };

  services.clipman.enable = true;
}
