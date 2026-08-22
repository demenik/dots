{
  name = "greetd-tuigreet";
  modules = [./default.nix];

  nixos = {
    pkgs,
    lib,
    config,
    ...
  }: let
    fallbackCmd =
      if (builtins.length config.greeter.sessions > 0)
      then builtins.head config.greeter.sessions
      else "${lib.getExe pkgs.bash}";
  in {
    services.greetd.settings.default_session.command = builtins.concatStringsSep " " [
      "${lib.getExe pkgs.tuigreet}"
      "--time"
      "--remember"
      "--remember-session"
      "--asterisks"
      "--sessions \"/run/current-system/sw/share/wayland-sessions:/run/current-system/sw/share/xsessions\""
      "--cmd \"${fallbackCmd}\""
    ];
  };
}
