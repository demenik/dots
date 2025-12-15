{pkgs, ...}: {
  programs.eza = {
    enable = true;
    enableZshIntegration = true;

    colors = "auto";
    extraOptions = [
      "--classify"
      "--group-directories-first"
    ];

    theme = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/eza-community/eza-themes/17095bff4792eecd7f4f1ed8301b15000331c906/themes/catppuccin.yml";
      sha256 = "0hpchiiadyxfl5rx12msww94jbj5hvqma5b2jgcvllv1b2pd1ghd";
    };
  };

  home.shellAliases = {
    ls = "eza";
  };
}
