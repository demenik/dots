{
  name = "nautilus";

  moduleConfig = {
    wm.binds = [
      {
        modifiers = ["SUPER"];
        key = "e";
        exec = "nautilus";
      }
    ];
  };

  home = {
    pkgs,
    lib,
    config,
    ...
  }: let
    nautilus-wrapped = pkgs.symlinkJoin {
      name = "nautilus";
      paths = [pkgs.nautilus];
      buildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/nautilus \
          --prefix PYTHONPATH : "${pkgs.python3.pkgs.pygobject3}/${pkgs.python3.sitePackages}" \
          --prefix XDG_DATA_DIRS : "${pkgs.nautilus-open-any-terminal}/share" \
          --set NAUTILUS_4_EXTENSION_DIR "${pkgs.nautilus-python}/lib/nautilus/extensions-4"
      '';
    };
  in {
    home.packages = with pkgs; [
      gvfs
      tinysparql
      localsearch

      nautilus-wrapped
    ];

    dconf.settings."com/github/stunkymonkey/nautilus-open-any-terminal" = lib.mkIf (config.terminal.windowClass != null) {
      terminal = config.terminal.windowClass;
      lockAll = true;
    };

    gtk = {
      enable = true;
      gtk3.bookmarks = let
        home = config.home.homeDirectory;
      in [
        "file:///"
        "file://${home}/Downloads"
        "file://${home}/dev"
        "file://${home}/dots"
        "file://${home}/uni"
        "file://${home}/Documents"
      ];
    };

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "inode/directory" = ["org.gnome.Nautilus.desktop"];

        "application/zip" = ["org.gnome.Nautilus.desktop"];
        "application/x-tar" = ["org.gnome.Nautilus.desktop"];
        "application/x-7z-compressed" = ["org.gnome.Nautilus.desktop"];
        "application/x-rar" = ["org.gnome.Nautilus.desktop"];
        "application/x-gzip" = ["org.gnome.Nautilus.desktop"];
        "application/x-bzip2" = ["org.gnome.Nautilus.desktop"];
        "application/x-xz" = ["org.gnome.Nautilus.desktop"];
      };
    };
  };
}
