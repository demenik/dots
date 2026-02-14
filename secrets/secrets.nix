let
  pubKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE+jwmNk9ciSlN/hEKXYGPLBE7lma1tqevXje0EKqqlp agenix";

  ageFiles = [
    "nextcloud-music"
    "anki"
    "eduroam"
  ];
in
  builtins.listToAttrs (map (file: {
      name = "${file}.age";
      value = {publicKeys = [pubKey];};
    })
    ageFiles)
