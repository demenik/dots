{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    matchBlocks = {
      "*" = {
        identityFile = "~/.ssh/id_rsa";
      };
      "homelab" = {
        hostname = "46.5.154.149";
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
    };
  };
}
