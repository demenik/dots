{user, ...}: {
  networking.wireless = {
    enable = true;
    networks = {
      eduroam = {
        auth = ''
          proto=RSN
          key_mgmt=WPA-EAP
          eap=PEAP
          identity="dominik.bernroider@uni-ulm.de"
          password=hash:9446aa5c94d8f72165905212d0e62d36
          phase1="peaplabel=0"
          phase2="auth=MSCHAPV2"
          ca_cert="/home/${user}/.config/cat_installer/ca.pem"
        '';
      };
    };
  };
}
