{
  name = "utils";

  home = {pkgs, ...}: {
    home.packages = with pkgs; [
      jq
      tree
      ncdu
    ];
  };
}
