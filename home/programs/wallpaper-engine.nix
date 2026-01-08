{
  pkgs,
  inputs,
  lib,
  config,
  ...
}: {
  home.packages = let
    wallpaperengine-gui = pkgs.stdenv.mkDerivation {
      pname = "simple-linux-wallpaperengine-gui";
      version = "0-unstable-2025-12-29";
      src = inputs.wallpaperengine-gui;

      nativeBuildInputs = with pkgs; [
        cmake
        qt6.wrapQtAppsHook
        makeWrapper
      ];
      buildInputs = with pkgs; [
        qt6.qtbase
        qt6.qtwebengine
        qt6.qtmultimedia
      ];

      postInstall = ''
        wrapProgram $out/bin/wallpaperengine-gui \
          --prefix PATH : ${lib.makeBinPath [pkgs.linux-wallpaperengine]}
      '';

      meta = with lib; {
        description = "Simple GUI for linux-wallpaperengine on C++.";
        homepage = "https://github.com/MikiDevLog/wallpaperengine-gui";
        license = licenses.mit;
        platforms = platforms.linux;
        mainProgram = "wallpaperengine-gui";
      };
    };
  in [
    wallpaperengine-gui
  ];

  services.linux-wallpaperengine = {
    enable = true;
    wallpapers =
      map (monitor: {
        inherit monitor;
        wallpaperId = "1200920610";
        scaling = "fill";
      }) [
        "HDMI-A-1"
        "DP-1"
        "eDP-1"
      ];
  };

  systemd.user.services.linux-wallpaperengine.Service = {
    Environment = ["XDG_SESSION_TYPE=wayland"];
  };
}
