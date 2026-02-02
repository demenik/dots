{
  imports = [
    ./cmp.nix
  ];

  programs.nixvim = {
    plugins = {
      emmet.enable = true;
      # copilot-lua = import ./copilot.nix;
    };
  };
}
