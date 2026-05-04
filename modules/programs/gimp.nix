{
  name = "gimp";

  home = {pkgs, ...}: {
    home.packages = [pkgs.gimp];

    xdg.mimeApps.defaultApplications = {
      "image/jpeg" = ["gimp.desktop"];
      "image/png" = ["gimp.desktop"];
      "image/gif" = ["gimp.desktop"];
      "image/bmp" = ["gimp.desktop"];
      "image/tiff" = ["gimp.desktop"];
      "image/webp" = ["gimp.desktop"];
      "image/x-tga" = ["gimp.desktop"];
    };
  };
}
