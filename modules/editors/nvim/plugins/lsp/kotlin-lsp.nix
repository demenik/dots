{
  lib,
  stdenv,
  fetchzip,
  makeWrapper,
  autoPatchelfHook,
  zlib,
}:
stdenv.mkDerivation rec {
  pname = "kotlin-lsp";
  version = "262.4739.0";

  src = fetchzip {
    url = "https://download-cdn.jetbrains.com/kotlin-lsp/${version}/kotlin-server-${version}.tar.gz";
    hash = "sha256-V4w2gnwJCrW0+iNyKrGsd+wXGBUoI/BoVYSxlHVzo64=";
    stripRoot = false;
  };

  nativeBuildInputs = [
    makeWrapper
    autoPatchelfHook
  ];
  buildInputs = [
    stdenv.cc.cc.lib
    zlib
  ];

  autoPatchelfIgnoreMissingDeps = true;

  installPhase = ''
    runHook preInstall

    cd kotlin-server-* || cd .

    rm -f bin/libgcompat-ext.so

    mkdir -p "$out"/bin "$out"/libexec/kotlin-lsp
    cp -r * "$out"/libexec/kotlin-lsp/

    TARGET_BIN="$out/libexec/kotlin-lsp/bin/intellij-server"
    chmod +x "$TARGET_BIN"

    makeWrapper "$TARGET_BIN" "$out"/bin/kotlin-lsp

    runHook postInstall
  '';

  meta = {
    description = "Kotlin Language Server (Standalone Binary)";
    homepage = "https://github.com/Kotlin/kotlin-lsp";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
  };
}
