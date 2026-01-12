{
  pkgs,
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
        --set NAUTILUS_4_EXTENSION_DIR "${pkgs.nautilus-python}/lib/nautilus/extensions-4"
    '';
  };
in {
  home.packages = with pkgs; [
    nautilus-wrapped
    nautilus-python
    nautilus-open-any-terminal
  ];

  dconf.settings."com/github/stunkymonkey/nautilus-open-any-terminal" = {
    terminal = config.home.sessionVariables.TERMINAL;
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

  wayland.windowManager.hyprland.settings.bind = [
    "SUPER, e, exec, nautilus"
  ];
}
