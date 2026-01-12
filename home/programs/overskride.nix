{pkgs, ...}: {
  home.packages = with pkgs; [
    overskride
  ];

  wayland.windowManager.hyprland.settings.windowrule = [
    {
      name = "overskride";
      "match:class" = "^(io.github.kaii_lb.Overskride)$";

      float = true;
      size = "850 650";
      center = true;
    }
  ];
}
