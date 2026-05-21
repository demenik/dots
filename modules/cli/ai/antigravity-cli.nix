{
  name = "antigravity-cli";

  modules = [./default.nix];

  home = {pkgs, ...}: let
    antigravity-cli = let
      version = "1.0.0-5288553236791296";
    in
      pkgs.stdenv.mkDerivation {
        pname = "antigravity-cli";
        version = "1.0.0";

        src = pkgs.fetchurl {
          url = "https://storage.googleapis.com/antigravity-public/antigravity-cli/${version}/linux-x64/cli_linux_x64.tar.gz";
          sha256 = "sha256-cAljQFdPr8SgbE08gFcxTiLUdc4cgg0K1R/wf7fpnrY=";
        };

        nativeBuildInputs = [pkgs.autoPatchelfHook];

        buildInputs = with pkgs; [
          stdenv.cc.cc.lib
        ];

        dontBuild = true;
        dontConfigure = true;

        unpackPhase = ''
          mkdir -p source
          tar -xzf "$src" -C source
        '';
        sourceRoot = "source";

        installPhase = ''
          mkdir -p "$out"/bin
          cp antigravity "$out"/bin/agy
          chmod +x "$out"/bin/agy
        '';
      };
  in {
    home.packages = [antigravity-cli];
  };
}
