{
  config,
  lib,
  ...
}: {
  programs.hyprlock = {
    enable = true;

    settings = let
      profilePhoto = "/var/lib/greeter-assets/user.png";
      font_family = config.stylix.fonts.sansSerif.name;

      inherit (config.lib.stylix) colors;
      background = colors.base00;
      text = colors.base05;
      yellow = colors.base0A;
      red = colors.base08;
      accent = colors.base0D;
    in {
      authentication.fingerprint.enabled = true;

      background = lib.mkForce [
        {
          monitor = "";
          path = "screenshot";
          color = "rgb(${background})";

          blur_size = 4;
          blur_passes = 3;
          noise = 0.0117;
          contrast = 0.8916;
          brightness = 0.8172;
          vibrancy = 0.1696;
          vibrancy_darkness = 0.0;
        }
      ];

      general = {
        hide_cursor = true;
        ignore_empty_input = false;
        grace = 0;
        no_fade_in = false;
      };

      input-field = lib.mkForce (map (monitor: {
        inherit monitor;
        size = "250, 60";
        position = "0, -225";

        outline_thickness = 2;
        dots_size = 0.2;
        dots_spacing = 0.2;
        dots_center = true;
        fade_on_empty = false;

        inherit font_family;
        outer_color = "rgba(0, 0, 0, 0)";
        inner_color = "rgba(100, 114, 125, 0.4)";
        font_color = "rgb(${text})";
        capslock_color = "rgb(${yellow})";
        check_color = "rgb(${accent})";
        fail_color = "rgb(${red})";

        placeholder_text =
          # html
          ''
            <i><span foreground="##${text}99"> 󰌾 Enter Password... </span></i>
          '';
        fail_text =
          # html
          ''
            <i>$FAIL <b>($ATTEMPTS)</b></i>
          '';
      }) ["HDMI-A-1" "eDP-1"]);

      label = builtins.concatMap (monitor: [
        # Keyboard Layout
        {
          inherit monitor;
          text = "$LAYOUT";
          font_size = 12;
          position = "30, -30";
          halign = "left";
          valign = "top";

          inherit font_family;
          color = "#rgba(${text}77)";
        }
        # Time
        {
          inherit monitor;
          text = "cmd[update:1000] echo \"$(date +\"%H:%M\")\"";
          font_size = 130;
          position = "0, 240";

          color = "rgb(${text})";
          inherit font_family;
        }
        # Day-Month
        {
          inherit monitor;
          text = "cmd[update:43200000] echo -e \"$(date +\"%A, %d. %B %Y\")\"";
          font_size = 30;
          position = "0, 105";

          color = "rgb(${text})";
          inherit font_family;
        }
        # Username
        {
          inherit monitor;
          text = "$USER";
          font_size = 24;
          position = "0, -130";

          color = "rgb(${text})";
          inherit font_family;
        }
      ]) ["HDMI-A-1" "eDP-1"];

      image = map (monitor: {
        # Profile Photo
        inherit monitor;
        path = profilePhoto;
        size = 120;
        position = "0, -20";

        border_size = 0;
        rounding = 0;
      }) ["HDMI-A-1" "eDP-1"];
    };
  };
}
