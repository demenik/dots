{
  moduleConfig = {
    wm.binds = [
      {
        modifiers = ["SUPER" "SHIFT"];
        key = "s";
        exec = "noctalia-shell ipc call plugin:screen-toolkit annotate";
      }
      {
        modifiers = ["SUPER" "SHIFT"];
        key = "r";
        exec = "noctalia-shell ipc call plugin:screen-toolkit recordMp4";
      }
    ];
  };

  home = {pkgs, ...}: {
    programs.noctalia-shell = {
      plugins.states.screen-toolkit = {
        enabled = true;
        sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
      };

      wrapper = {
        packages = with pkgs; [
          # core
          grim
          slurp
          wl-clipboard
          tesseract
          imagemagick
          zbar
          curl
          ffmpeg
          jq
          wl-screenrec
          xdg-desktop-portal

          # color picker
          hyprpicker

          # optional
          translate-shell
          gifski
        ];

        pythonPackages = with pkgs.python3Packages; [
          pygobject3
        ];

        extraPostBuild =
          # bash
          ''
            wrapProgram "$out"/bin/noctalia-shell \
              --run 'for f in ~/.config/noctalia/plugins/screen-toolkit/scripts/*.sh; do [ -f "$f" ] && sed -i "1s|^.*$|#!/usr/bin/env bash|" "$f"; done'
          '';
      };
    };
  };
}
