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
}
