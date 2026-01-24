{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    matchBlocks = {
      "*" = {
        identityFile = "~/.ssh/id_ed25519";
      };
      "homelab" = {
        hostname = "192.168.178.197";
        user = "nix";
      };
      "hyperion" = {
        hostname = "192.168.178.55";
        user = "demenik";
      };
      "sgi-uni-ulm" = {
        hostname = "login.informatik.uni-ulm.de";
        user = "db56";
      };
      "github.com" = {
        user = "git";
        identitiesOnly = true;
      };
      "gitlab.uni-ulm.de" = {
        user = "git";
        identitiesOnly = true;
      };
      "lg" = {
        hostname = "192.168.178.160";
        user = "root";
      };
    };
  };
}
