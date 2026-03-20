{
  modules = [../../modules/services/wallpaper-engine.nix];

  moduleConfig = let
    wallpapers = {
      red-eva-asuka = {
        wallpaperId = "1200920610";
        scaling = "fill";
      };
    };
  in {
    wallpaperEngine.wallpapers = {
      "*" = wallpapers.red-eva-asuka;
    };
  };
}
