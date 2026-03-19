{lib, ...}: {
  name = "greetd";
  modules = [./default.nix];

  nixos = {
    pkgs,
    config,
    ...
  }: let
    fallbackCmd =
      if (builtins.length config.dots.sessions > 0)
      then builtins.head config.dots.sessions
      else "${lib.getExe pkgs.bash}";
  in {
    services.greetd = {
      enable = true;
      settings = {
        user = "greetd";
        command = ''
          ${lib.getExe pkgs.tuigreet} \
            --time \
            --remember \
            --remmeber-session \
            --asterisks \
            --sessions "/run/current-system/sw/share/wayland-sessions:/run/current-system/sw/share/xsessions" \
            --cmd "${fallbackCmd}"
        '';
      };
    };
  };
}
