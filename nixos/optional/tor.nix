{
  services.tor = {
    enable = true;
    client.enable = true;
  };

  services.privoxy = {
    enable = true;
    settings = {
      listen-address = "127.0.0.1:8118";
      forward-socks5t = "/ 127.0.0.1:9050 .";
    };
  };
}
