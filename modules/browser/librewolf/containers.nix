{
  programs.librewolf.profiles.default = {
    containersForce = true;
    containers = {
      Private = {
        name = "Private";
        id = 10;
        icon = "circle";
        color = "purple";
      };
      Uni = {
        name = "Uni";
        id = 6;
        icon = "circle";
        color = "pink";
      };
      Work = {
        name = "Work";
        id = 9;
        icon = "circle";
        color = "red";
      };
      I2P = {
        name = "I2P";
        id = 7;
        icon = "circle";
        color = "orange";
      };
      Tor = {
        name = "Tor";
        id = 8;
        icon = "circle";
        color = "yellow";
      };
    };
  };
}
