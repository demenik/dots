{config, ...}: let
  eduroam = config.age.secrets.eduroam.path;
in {
  networking.wireless = {
    enable = true;
    secretsFile = eduroam;
  };
}
