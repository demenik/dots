{
  name = "networkmanager";

  nixos = {
    lib,
    users,
    ...
  }: {
    networking.networkmanager.enable = true;

    users.users = lib.genAttrs (map (u: u.username) users) (name: {
      extraGroups = ["networkmanager"];
    });
  };
}
