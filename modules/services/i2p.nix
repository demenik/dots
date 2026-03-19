{
  name = "i2p";

  nixos = {
    services.i2pd = {
      enable = true;
      proto = {
        httpProxy.enable = true;
        socksProxy.enable = true;
      };
    };
  };
}
