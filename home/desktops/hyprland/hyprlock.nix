{
  config,
  lib,
  ...
}: {
  programs.hyprlock = {
    enable = true;

    settings = let
      profilePhoto = "$HOME/Pictures/pfp/bladee/egobaby.jpg";
      wallpaper = "$HOME/Pictures/wallpapers/takopi/class.png";
      font_family = config.stylix.fonts.sansSerif.name;

      inherit (config.lib.stylix) colors;
      text = colors.base05;
      yellow = colors.base0A;
      accent = colors.base0D;
    in {
      authentication.fingerprint.enabled = true;

      background = {
        monitor = "";
        path = wallpaper;
        blur_passes = 0;
        blur_size = 8;
      };

      general = {
        hide_cursor = true;
        ignore_empty_input = true;
      };

      input-field = {
        monitor = "";
        size = "250, 60";
        position = "0, -225";
        outline_thickness = 2;
        dots_size = 0.2;
        dots_spacing = 0.2;
        dots_center = true;
        outer_color = lib.mkForce "rgba(0, 0, 0, 0)";
        inner_color = lib.mkForce "rgba(100, 114, 125, 0.4)";
        font_color = lib.mkForce "rgb(${text})";
        fade_on_empty = false;
        inherit font_family;
        placeholder_text = "<span foreground=\"##${text}99\"><i>󰌾 Login as </i><span foreground=\"##${accent}ff\">$USER</span></span>";
        fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
        capslock_color = "rgb(${yellow})";
        check_color = lib.mkForce "rgb(${accent})";
      };

      label = [
        # Layout
        {
          monitor = "";
          text = "Layout: $LAYOUT";
          color = "#rgb(${text})";
          font_size = 12;
          inherit font_family;
          position = "30, -30";
          halign = "left";
          valign = "top";
        }
        # Time
        {
          monitor = "";
          text = "cmd[update:1000] echo \"$(date +\"%H:%M\")\"";
          color = "rgb(${text})";
          font_size = 130;
          inherit font_family;
          position = "0, 240";
        }
        # Day-Month
        {
          monitor = "";
          text = "cmd[update:43200000] echo -e \"$(date +\"%A, %d. %B %Y\")\"";
          color = "rgb(${text})";
          font_size = 30;
          inherit font_family;
          position = "0, 105";
        }
        # Fingerprint
        {
          monitor = "";
          text = "$FPRINTPROMPT";
          color = "rgb(${text})";
          font_size = 14;
          inherit font_family;
          position = "0, -130";
        }
      ];

      # image = [
      #   # Profile Photo
      #   {
      #     monitor = "";
      #     path = profilePhoto;
      #     border_size = 0;
      #     size = 120;
      #     rounding = -1;
      #     rotate = 0;
      #     position = "0, -20";
      #   }
      # ];
    };
  };
}
