{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # dvd
    libdvdcss
    libdvdread
    libdvdnav
    # blu-ray
    libaacs
    libbdplus

    makemkv # ripping
  ];

  boot.kernelModules = ["sg"];

  systemd.user.services.update-aacs-keys = {
    description = "Update AACS KEYDB.cfg for Blu-ray decryption";
    after = ["network-online.target"];
    wantedBy = ["default.target"];

    serviceConfig = {
      Type = "oneshot";
      ExecStartPre = "${pkgs.uutils-coreutils-noprefix}/bin/mkdir -p %h/.config/aacs";
      ExecStart = "${pkgs.lib.getExe pkgs.curl} -sL -o %h/.config/aacs/KEYDB.cfg http://vlc-bluray.whoknowsmy.name/files/KEYDB.cfg";
    };
  };
}
