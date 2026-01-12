{
  pkgs,
  lib,
  ...
}: {
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = ''
          ${pkgs.tuigreet}/bin/tuigreet \
            --cmd "${lib.getExe' pkgs.hyprland "start-hyprland"}" \
            --remember \
            --remember-session \
            --asterisks
        '';
        user = "demenik";
      };
    };
  };
}
