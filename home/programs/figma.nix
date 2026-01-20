{pkgs, ...}: {
  home.packages = with pkgs; [
    figma-linux
  ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/figma" = ["figma-linux.desktop"];
    };
  };
}
