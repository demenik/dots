{
  name = "greetd";
  modules = [../default.nix];

  nixos = {
    services.greetd = {
      enable = true;
      settings.default_session.user = "greeter";
    };
  };
}
