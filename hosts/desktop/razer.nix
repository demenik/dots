{
  pkgs,
  users,
  ...
}: {
  hardware.openrazer = {
    enable = true;
    users = map (user: user.username) users;
  };

  environment.systemPackages = [
    pkgs.polychromatic
  ];
}
