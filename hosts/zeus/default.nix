{
  system = "x86_64-linux";
  stateVersion = "25.05";
  hmStateVersion = "25.05";

  users = [../../users/tct47];
  modules = [
    ../../modules/system/nix-portable.nix
  ];

  homeConfig = {
    git.signing = {
      pubKeyPath = "~/.ssh/id_ed25519.pub";
      pubKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPu68pHva1HqWiO4NRjI397+/xSxp5Vv9sFmIvXMKgfP tct47@zeus";
    };

    home.sessionVariables = {
      NP_RUNTIME = "proot";
      SSL_CERT_FILE = "/etc/ssl/ca-bundle.pem";
    };
  };
}
