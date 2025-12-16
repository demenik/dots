{
  inputs,
  pkgs,
  user,
  ...
}: let
  ageFiles = builtins.attrNames (import ./secrets.nix);
  ageNames =
    map (
      name:
        with builtins;
          substring 0 (stringLength name - 4) name
    )
    ageFiles;
in {
  home.packages = with inputs; [
    agenix.packages."${pkgs.stdenv.hostPlatform.system}".default
  ];

  age = {
    identityPaths = ["/home/${user}/.ssh/id_ed25519"];

    secrets = builtins.listToAttrs (map (name: {
        inherit name;
        value.file = ./${name}.age;
      })
      ageNames);
  };
}
