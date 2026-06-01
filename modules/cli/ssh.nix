{
  name = "ssh";

  home = {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;

      settings = {
        "*".identityFile = "~/.ssh/id_ed25519";

        "homelab" = {
          hostname = "192.168.178.197";
          user = "nix";
          port = 22000;
        };

        "sgi-uni-ulm" = {
          hostname = "zeus.rz.uni-ulm.de";
          user = "tct47";
        };

        "lg" = {
          hostname = "192.168.178.160";
          user = "root";
          identitiesOnly = true;
        };
        "hyperion" = {
          hostname = "192.168.178.55";
          user = "demenik";
        };

        "github.com" = {
          user = "git";
          identitiesOnly = true;
        };
        "gitea.demenik.dev" = {
          user = "git";
          identitiesOnly = true;
        };
        "gitlab.uni-ulm.de" = {
          user = "git";
          identitiesOnly = true;
        };
        "spgit.informatik.uni-ulm.de" = {
          user = "git";
          identitiesOnly = true;
        };

        "ctf-lab" = {
          hostname = "ctf-lab.lxd-vs.uni-ulm.de";
          user = "ctf";
          identitiesOnly = true;
        };
      };
    };
  };
}
