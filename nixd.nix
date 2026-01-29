let
  flake = builtins.getFlake (toString ./.);
  hmConfig = flake.homeConfigurations."demenik@desktop";
in
{
  nixos = flake.nixosConfigurations.desktop.options;
  home_manager = hmConfig.options;
  nixvim = hmConfig.options.programs.nixvim.type.getSubOptions [];
}
