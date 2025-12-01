{
  pkgs,
  user,
  ...
}: {
  programs.wireshark.enable = true;
  environment.systemPackages = with pkgs; [wireshark-qt];

  users.users."${user}".extraGroups = ["wireshark"];
}
