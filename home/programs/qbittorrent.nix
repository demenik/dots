{pkgs, ...}: {
  home.packages = with pkgs; [qbittorrent];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/magnet" = ["org.qbittorrent.qBittorrent.desktop"];
    };
  };

  programs.firefox.policies.Handlers = {
    schemes.magnet = {
      action = "useHelperApp";
      handlers = [
        {
          name = "qBittorrent";
          path = "${pkgs.qbittorrent}/share/application/org.qbittorrent.qBittorrent.desktop";
        }
      ];
    };
  };
}
