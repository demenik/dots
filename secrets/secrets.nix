let
  pubKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE+jwmNk9ciSlN/hEKXYGPLBE7lma1tqevXje0EKqqlp demenik@thinkpad";

  ageFiles = [
    "obsidian-personal"
    "obsidian-uni-notes"
    "nextcloud"
  ];
in
  builtins.listToAttrs (map (file: {
      name = "${file}.age";
      value = {publicKeys = [pubKey];};
    })
    ageFiles)
