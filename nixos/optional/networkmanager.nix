{user, ...}: {
  networking.networkmanager.enable = true;
  users.users."${user}".extraGroups = ["networkmanager"];

  # networking.networkmanager.dns = "none";
  # networking.useDHCP = false;
  # networking.dhcpcd.enable = false;
  # networking.nameservers = [ homelabipv4 "8.8.8.8" ];
}
