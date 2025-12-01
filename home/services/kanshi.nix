{
  services.kanshi = {
    enable = true;
    settings = let
      enableLaptopDock = false;

      laptop = {
        criteria = "eDP-1";
        mode = "1920x1200@60";
        scale = 1.25;
        status = "enable";
      };
      laptopDock =
        if enableLaptopDock
        then laptop
        else {
          inherit (laptop) criteria;
          status = "disable";
        };

      samsungDock = {
        criteria = "Samsung Electric Company LC24RG50 HTHM300134";
        mode = "1920x1080@144";
        scale = 1.0;
        status = "enable";
      };

      collegeDock = {
        criteria = "Dell Inc. DELL U2515H 9X2VY54S0QNL";
        mode = "1920x1080@60";
        scale = 1.0;
        status = "enable";
      };

      mkSensitivity = val: "hyprctl keyword input:sensitivity ${val}";
    in [
      {
        profile = {
          name = "laptop";
          outputs = [laptop];
          exec = [(mkSensitivity "0.0")];
        };
      }
      {
        profile = {
          name = "dock@home";
          outputs = [samsungDock laptopDock];
          exec = [(mkSensitivity "-0.5")];
        };
      }
      {
        profile = {
          name = "dock@college";
          outputs = [collegeDock laptopDock];
          exec = [(mkSensitivity "-0.5")];
        };
      }
    ];
  };
}
