{
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "hyprlock";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };

      listener = [
        {
          timeout = 60;
          on-timeout = "brightnessctl -sd rgb:kbd_backlight set 0";
          on-resume = "brightnessctl -rd rgb:kbd_backlight";
        }
        {
          timeout = 3 * 60;
          on-timeout = "brightnessctl set 10%";
          on-resume = "brightnessctl -r";
        }
        {
          timeout = 5 * 60;
          on-timeout = "hyprlock";
        }
        {
          timeout = 10 * 60;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 20 * 60;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };
}
