{
  pkgs,
  user,
  ...
}: {
  programs.wireshark.enable = true;
  environment.systemPackages = with pkgs; [wireshark];

  users.users."${user}".extraGroups = ["wireshark"];
}
