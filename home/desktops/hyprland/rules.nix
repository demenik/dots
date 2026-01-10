{
  layer = [];

  window =
    [
      "float, class:^(hyprland-share-picker)$"
      "workspace 3, class:^(Electron)$, title:^(BSC)$" # BetterSoundCloud
      "workspace 3, class:^(opensoundcloud)$"

      "noinitialfocus, floating:0" # Dont focus tiling windows on startup
    ]
    ++ map (rule: "${rule}, class:^(xdg-desktop-portal-gtk)$") [
      "float"
      "size 800 600"
      "center 1"
      "dimaround"
    ];

  workspace = [];
}
