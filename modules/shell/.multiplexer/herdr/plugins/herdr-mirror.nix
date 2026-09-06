{
  home = {pkgs, ...}: let
    version = "0.4.3";

    plat = {
      x86_64-linux = {
        arch = "x86_64";
        hash = "sha256-FbZLS5OljpTnDmm0YhQGma/7soYxc35TnMo0vAnptig=";
      };
      aarch64-linux = {
        arch = "aarch64";
        hash = "sha256-eYmIMgVn3A3R+uiqczrW+Ffx3Hk8+8+fqBEgr0WniX8=";
      };
    };
    inherit (plat.${pkgs.stdenv.hostPlatform.system}) arch hash;

    src = pkgs.fetchFromGitHub {
      owner = "nikok6";
      repo = "herdr-mirror";
      rev = "195398c1275f9f3d18ddff70282149005a2bec01";
      hash = "sha256-dZIu4TcMkVDrRvnvgRMh7+8PpNaWB/i2/UkH/h0ZRW4=";
    };

    bin = pkgs.fetchurl {
      url = "https://github.com/nikok6/herdr-mirror/releases/download/v${version}/herdr-mirror-linux-${arch}";
      inherit hash;
    };
  in {
    programs.herdr.plugins = [
      {
        package = pkgs.runCommand "herdr-mirror-${version}" {} ''
          cp -r "${src}" "$out"
          chmod -R u+w "$out"
          install -Dm755 "${bin}" "$out"/target/release/herdr-mirror
        '';
        runtimeInputs = [pkgs.openssh];
      }
    ];
  };
}
