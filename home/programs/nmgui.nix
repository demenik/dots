{pkgs, ...}: {
  home.packages = with pkgs; [
    nmgui
  ];

  wayland.windowManager.hyprland.settings.windowrule = [
    {
      name = "nmgui";
      "match:class" = "^(com.network.manager)$";

      float = true;
      size = "500 600";
      center = true;
    }
  ];
}
