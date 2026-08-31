{
  name = "i2p";

  nixos = {
    services.i2pd = {
      enable = true;
      settings = {
        httpproxy.enabled = true;
        socksproxy.enabled = true;
      };
    };
  };
}
