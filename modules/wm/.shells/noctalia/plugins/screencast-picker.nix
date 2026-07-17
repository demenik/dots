{
  lib,
  config,
  ...
}:
lib.mkIf (config.services ? xdph) {
  programs.noctalia-shell.plugins = {
    states."563115:screencast-picker" = {
      enabled = true;
      sourceUrl = "https://github.com/demenik/noctalia-v4-plugins";
    };
  };

  services.xdph.settings = {
    screencopy.customPickerBinary = "${config.xdg.configHome}/noctalia/plugins/563115:screencast-picker/scripts/pick.sh";
  };
}
