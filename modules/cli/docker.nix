{
  name = "docker";

  nixos = {
    lib,
    users,
    ...
  }: {
    virtualisation.docker = {
      enable = true;
      rootless.enable = true;
    };

    users.users = lib.genAttrs (map (u: u.username) users) (name: {
      extraGroups = ["docker"];
    });
  };
}
