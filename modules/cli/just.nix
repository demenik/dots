{
  name = "just";

  home = {pkgs, ...}: {
    home.packages = with pkgs; [
      just
    ];
  };
}
