{
  stdenv,
  fetchurl,
}:
stdenv.mkDerivation rec {
  pname = "dwproton";
  version = "dwproton-10.0-21";

  src = fetchurl {
    url = "https://dawn.wine/dawn-winery/dwproton/releases/download/${version}/${version}-x86_64.tar.xz";
    hash = "sha256-s5/i/YVyewgYq1lijhRmwNuLqMMSdn4V57wGmcSilVg=";
  };

  phases = ["installPhase"];

  installPhase = ''
    mkdir -p "$out"
    tar -xf "$src" -C "$out" --strip-components=1
  '';

  meta = {
    description = "Dawn Winery's custom Proton fork with fixes for various games";
    homepage = "https://dawn.wine/dawn-winery/dwproton";
  };
}
