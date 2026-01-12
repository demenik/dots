{pkgs, ...}: {
  home.packages = with pkgs; [
    ryubing
  ];

  wayland.windowManager.hyprland.settings.windowrule = [
    {
      name = "ryujinx";
      "match:class" = "^(Ryujinx)$";

      no_blur = true;
      no_shadow = true;

      immediate = true;
      idle_inhibit = "focus";
      workspace = 1;
      center = true;
    }
  ];
}
