{pkgs, ...}: {
  nix = {
    package = pkgs.nix;

    settings = {
      auto-optimise-store = true;
      trusted-users = ["root" "@wheel"];
      experimental-features = "nix-command flakes";
      warn-dirty = false;
      download-buffer-size = 512 * 1024 * 1024; # 512 MiB
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  nixpkgs.config.allowUnfree = true;
}
