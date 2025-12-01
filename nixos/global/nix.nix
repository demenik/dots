{pkgs, ...}: {
  nix = {
    package = pkgs.nix;

    settings = {
      auto-optimise-store = true;
      trusted-users = ["root" "@wheel"];
      experimental-features = "nix-command flakes";
      warn-dirty = false;
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 2d";
    };
    optimise.automatic = true;
  };

  nixpkgs.config.allowUnfree = true;
}
