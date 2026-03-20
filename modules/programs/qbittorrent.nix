{
  name = "qbittorrent";

  home = {pkgs, ...}: {
    home.packages = with pkgs; [qbittorrent];

    xdg.configFile."qBittorrent/themes/catppuccin-mocha.qbtheme".source = pkgs.fetchurl {
      url = "https://github.com/catppuccin/qbittorrent/releases/download/v2.0.1/catppuccin-mocha.qbtheme";
      hash = "";
    };

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "x-scheme-handler/magnet" = ["org.qbittorrent.qBittorrent.desktop"];
      };
    };

    programs.librewolf.policies.Handlers = {
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
  };
}
