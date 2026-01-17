{
  inputs,
  pkgs,
  user,
  ...
}: let
  mkSecret = name: opts: {
    inherit name;
    value =
      opts
      // {
        file = ./${name}.age;
      };
  };
in {
  home.packages = with inputs; [
    agenix.packages."${pkgs.stdenv.hostPlatform.system}".default
  ];

  home.shellAliases = {
    agenix = "agenix -i ~/.ssh/id_agenix";
  };

  age = {
    identityPaths = ["/home/${user}/.ssh/id_agenix"];

    secrets = builtins.listToAttrs [
      (mkSecret "obsidian-personal" {})
      (mkSecret "obsidian-uni-notes" {})
      (mkSecret "nextcloud" {})
      (mkSecret "anki" {
        path = "/run/user/1000/agenix/anki";
      })
    ];
  };
}
