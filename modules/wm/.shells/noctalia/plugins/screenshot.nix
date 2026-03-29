{
  moduleConfig = {
    wm.binds = [
      {
        modifiers = ["SUPER" "SHIFT"];
        key = "s";
        exec = "noctalia-shell ipc call plugin:screen-shot-and-record screenshot";
      }
      {
        modifiers = ["SUPER" "SHIFT"];
        key = "r";
        exec = "noctalia-shell ipc call plugin:screen-shot-and-record record";
      }
      {
        modifiers = ["SUPER" "SHIFT"];
        key = "o";
        exec = "noctalia-shell ipc call plugin:screen-shot-and-record ocr";
      }
    ];
  };

  home = {pkgs, ...}: {
    programs.noctalia-shell = {
      plugins = {
        states.screen-shot-and-record = {
          enabled = true;
          sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
        };
      };
    };

    home.packages = with pkgs; [
      # screenshot
      grim
      imagemagick
      wl-clipboard
      swappy
      satty

      # ocr
      tesseract

      # google lens
      xdg-utils
      jq

      # screen recording
      wf-recorder
    ];
  };
}
