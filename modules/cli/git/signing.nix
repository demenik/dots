{
  lib,
  config,
  ...
}: let
  emails = [
    "mail@demenik.dev"
    "dominik.bernroider@uni-ulm.de"
  ];
in {
  home.file.".ssh/allowed_signers".text =
    lib.concatMapStrings (email: "${email} ${config.git.signing.pubKey}\n") emails;

  programs.git = {
    signing = {
      key = config.git.signing.pubKeyPath;
      signByDefault = true;
      format = "ssh";
    };

    settings = {
      gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
    };
  };
}
