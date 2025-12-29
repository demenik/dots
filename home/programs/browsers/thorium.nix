{
  inputs,
  pkgs,
  ...
}: {
  home.packages = let
    thorium = pkgs.symlinkJoin {
      name = "thorium";
      paths = [inputs.thorium.packages.${pkgs.stdenv.hostPlatform.system}.thorium-avx2];
      buildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram "$out"/bin/thorium \
          --add-flags "--enable-features=UseOzonePlatform" \
          --add-flags "--ozone-platform=wayland"
      '';
    };
  in [
    thorium
  ];
}
