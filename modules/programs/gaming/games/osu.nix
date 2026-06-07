{
  name = "osu";

  modules = [../default.nix];

  nixos = {
    hardware.opentabletdriver = {
      enable = true;
      daemon.enable = true;
    };
  };
  hostInstructions = ''
    Install opentabletdriver
  '';

  home = {pkgs, ...}: {
    home.packages = [pkgs.osu-lazer-bin];

    xdg = {
      dataFile."mime/packages/osu.xml".text =
        # xml
        ''
          <?xml version="1.0" encoding="utf-8"?>
          <mime-info xmlns="http://www.freedesktop.org/standards/shared-mime-info">
            <mime-type type="application/x-osu-beatmap-archive">
              <comment>osu! Beatmap Archive</comment>
              <glob pattern="*.osz" weight="60"/>
            </mime-type>

            <mime-type type="application/x-osu-skin-archive">
              <comment>osu! Skin Archive</comment>
              <glob pattern="*.osk" weight="60"/>
            </mime-type>

            <mime-type type="application/x-osu-beatmap">
              <comment>osu! Difficulty</comment>
              <glob pattern="*.osu" weight="60"/>
            </mime-type>

            <mime-type type="application/x-osu-storyboard">
              <comment>osu! Storyboard</comment>
              <glob pattern="*.osb" weight="60"/>
            </mime-type>

            <mime-type type="application/x-osu-replay">
              <comment>osu! Replay</comment>
              <glob pattern="*.osr" weight="60"/>
            </mime-type>
          </mime-info>
        '';

      mimeApps.defaultApplicationPackages = [pkgs.osu-lazer-bin];
    };
  };
}
