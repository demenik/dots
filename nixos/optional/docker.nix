{user, ...}: {
  virtualisation.docker = {
    enable = true;
    rootless.enable = true;
  };

  users.users.${user}.extraGroups = ["docker"];
}
