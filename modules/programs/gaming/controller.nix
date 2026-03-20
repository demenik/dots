{
  pkgs,
  lib,
  users,
  ...
}: {
  hardware.xpadneo.enable = true;

  services.udev.packages = with pkgs; [
    game-devices-udev-rules
  ];

  users.users = lib.genAttrs (map (u: u.username) users) (name: {
    extraGroups = ["input"];
  });

  environment.sessionVariables = {
    SDL_JOYSTICK_HIDAPI_XBOX = "0";
    SDL_JOYSTICK_HIDAPI_XBOX_ONE = "0";
  };
}
