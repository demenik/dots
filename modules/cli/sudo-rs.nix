{
  name = "sudo-rs";

  nixos.security = {
    rtkit.enable = true;
    sudo-rs = {
      enable = true;
      extraConfig = ''
        Defaults pwfeedback
      '';
    };
  };

  home.programs.zsh.initContent =
    # zsh
    ''
      sudo() {
        if [[ -n $SUDO_ASKPASS ]] && ! { : </dev/tty } 2>/dev/null; then
          command sudo -A "$@"
        else
          command sudo "$@"
        fi
      }
    '';
}
