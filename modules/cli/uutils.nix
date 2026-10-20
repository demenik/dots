{
  name = "uutils";

  modules = [../ai/.guidelines];

  nixos = {
    pkgs,
    lib,
    ...
  }: {
    environment.systemPackages = with pkgs; [
      (lib.hiPrio uutils-coreutils-noprefix)
    ];
  };

  home = {
    pkgs,
    lib,
    ...
  }: {
    home.packages = with pkgs; [
      (lib.hiPrio uutils-coreutils-noprefix)
    ];

    ai.guidelines.sections.tools.text = ''
      - Coreutils (`ls`, `cp`, `mv`, `sort`, ...) are provided by uutils (Rust rewrite) instead of GNU. They are largely compatible, but if a flag or output format behaves unexpectedly, suspect uutils differences.
    '';
  };
}
