{
  name = "wireshark";

  home = {pkgs, ...}: {
    home.packages = with pkgs; [
      wireshark
    ];
  };
}
