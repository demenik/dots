{
  name = "gaming";

  imports = [./wrapper.nix];

  moduleConfig = {
    config,
    lib,
    ...
  }: let
    monitor = config.wm.primaryMonitor;
    getMonitorAttr = path: default:
      if monitor == null
      then default
      else let
        val = lib.attrByPath path null monitor;
      in
        if val == null
        then default
        else val;
  in {
    programs.gaming.wrapper.defaults = {
      gamemode.enable = true;
      gamescope = {
        enable = false;
        args = {
          W = getMonitorAttr ["mode" "width"] 1920;
          H = getMonitorAttr ["mode" "height"] 1080;
          f = true;

          adaptive-sync = (getMonitorAttr ["vrr"] false) != false;
          hdr-enabled = (getMonitorAttr ["colorMode"] "auto") == "hdr";

          mangoapp = true;
        };
      };
    };
  };

  nixos = {
    imports = [./controller.nix];

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    programs.gamescope = {
      enable = true;
      capSysNice = true;
    };
    programs.gamemode = {
      enable = true;
      enableRenice = true;
      settings = {
        general.renice = true;
      };
    };
  };
}
