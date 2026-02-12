{
  imports = [
    ../services/kanshi.nix
  ];

  wayland.windowManager.hyprland.settings = {
    misc = {
      vfr = true;
      vrr = 0;
    };
    decoration = {
      shadow.enabled = false;
    };
  };
}
