{config, ...}: let
  id = "563115:polkit-agent";
in {
  programs.noctalia-shell.plugins.states.${id} = {
    enabled = true;
    sourceUrl = "https://github.com/demenik/noctalia-v4-plugins";
  };

  home.sessionVariables.SUDO_ASKPASS = "${config.xdg.configHome}/noctalia/plugins/${id}/bin/noctalia-askpass";
}
