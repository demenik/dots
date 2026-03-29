{
  system = "x86_64-linux";
  stateVersion = "25.11";
  hmStateVersion = "25.11";

  users = [../../users/nix];

  moduleConfig = {
    git.signing = {
      pubKeyPath = "~/.ssh/id_ed25519.pub";
      pubKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILpblJlRaKkplGykP/A3GwFJHV+0zS1xtosgzd41lceq nix@homelab";
    };
  };
}
