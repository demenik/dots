{pkgs, ...}: {
  home.pointerCursor = {
    enable = true;
    name = "McMojave-cursors";
    package = pkgs.mcmojave-cursors;
    size = 22;
    gtk.enable = true;
    x11.enable = true;
  };
}
