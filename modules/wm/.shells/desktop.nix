{
  name = "shells-desktop";

  modules = [
    ./default.nix

    ./gtk.nix
    ./qt.nix
  ];
}
