{
  stdenv,
  lib,
  fetchzip,
  makeWrapper,
  unzip,
  jdk17_headless,
}:
stdenv.mkDerivation rec {
  pname = "kotlin-lsp";
  version = "0.253.10629";

  src = fetchzip {
    url = "https://download-cdn.jetbrains.com/kotlin-lsp/${version}/kotlin-${version}.zip";
    hash = "sha256-LCLGo3Q8/4TYI7z50UdXAbtPNgzFYtmUY/kzo2JCln0=";
    stripRoot = false;
  };

  nativeBuildInputs = [
    makeWrapper
    unzip
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/libexec/kotlin-lsp
    cp -r $src/* $out/libexec/kotlin-lsp/

    makeWrapper ${jdk17_headless}/bin/java $out/bin/kotlin-lsp \
      --add-flags "--add-opens java.base/java.io=ALL-UNNAMED" \
      --add-flags "--add-opens java.base/java.lang=ALL-UNNAMED" \
      --add-flags "--add-opens java.base/java.lang.ref=ALL-UNNAMED" \
      --add-flags "--add-opens java.base/java.lang.reflect=ALL-UNNAMED" \
      --add-flags "--add-opens java.base/java.net=ALL-UNNAMED" \
      --add-flags "--add-opens java.base/java.nio=ALL-UNNAMED" \
      --add-flags "--add-opens java.base/java.nio.charset=ALL-UNNAMED" \
      --add-flags "--add-opens java.base/java.text=ALL-UNNAMED" \
      --add-flags "--add-opens java.base/java.time=ALL-UNNAMED" \
      --add-flags "--add-opens java.base/java.util=ALL-UNNAMED" \
      --add-flags "--add-opens java.base/java.util.concurrent=ALL-UNNAMED" \
      --add-flags "--add-opens java.base/java.util.concurrent.atomic=ALL-UNNAMED" \
      --add-flags "--add-opens java.base/java.util.concurrent.locks=ALL-UNNAMED" \
      --add-flags "--add-opens java.base/jdk.internal.vm=ALL-UNNAMED" \
      --add-flags "--add-opens java.base/sun.net.dns=ALL-UNNAMED" \
      --add-flags "--add-opens java.base/sun.nio.ch=ALL-UNNAMED" \
      --add-flags "--add-opens java.base/sun.nio.fs=ALL-UNNAMED" \
      --add-flags "--add-opens java.base/sun.security.ssl=ALL-UNNAMED" \
      --add-flags "--add-opens java.base/sun.security.util=ALL-UNNAMED" \
      --add-flags "--add-opens java.desktop/com.apple.eawt=ALL-UNNAMED" \
      --add-flags "--add-opens java.desktop/com.apple.eawt.event=ALL-UNNAMED" \
      --add-flags "--add-opens java.desktop/com.apple.laf=ALL-UNNAMED" \
      --add-flags "--add-opens java.desktop/com.sun.java.swing=ALL-UNNAMED" \
      --add-flags "--add-opens java.desktop/com.sun.java.swing.plaf.gtk=ALL-UNNAMED" \
      --add-flags "--add-opens java.desktop/java.awt=ALL-UNNAMED" \
      --add-flags "--add-opens java.desktop/java.awt.dnd.peer=ALL-UNNAMED" \
      --add-flags "--add-opens java.desktop/java.awt.event=ALL-UNNAMED" \
      --add-flags "--add-opens java.desktop/java.awt.font=ALL-UNNAMED" \
      --add-flags "--add-opens java.desktop/java.awt.image=ALL-UNNAMED" \
      --add-flags "--add-opens java.desktop/java.awt.peer=ALL-UNNAMED" \
      --add-flags "--add-opens java.desktop/javax.swing=ALL-UNNAMED" \
      --add-flags "--add-opens java.desktop/javax.swing.plaf.basic=ALL-UNNAMED" \
      --add-flags "--add-opens java.desktop/javax.swing.text=ALL-UNNAMED" \
      --add-flags "--add-opens java.desktop/javax.swing.text.html=ALL-UNNAMED" \
      --add-flags "--add-opens java.desktop/sun.awt=ALL-UNNAMED" \
      --add-flags "--add-opens java.desktop/sun.awt.X11=ALL-UNNAMED" \
      --add-flags "--add-opens java.desktop/sun.awt.datatransfer=ALL-UNNAMED" \
      --add-flags "--add-opens java.desktop/sun.awt.image=ALL-UNNAMED" \
      --add-flags "--add-opens java.desktop/sun.awt.windows=ALL-UNNAMED" \
      --add-flags "--add-opens java.desktop/sun.font=ALL-UNNAMED" \
      --add-flags "--add-opens java.desktop/sun.java2d=ALL-UNNAMED" \
      --add-flags "--add-opens java.desktop/sun.lwawt=ALL-UNNAMED" \
      --add-flags "--add-opens java.desktop/sun.lwawt.macosx=ALL-UNNAMED" \
      --add-flags "--add-opens java.desktop/sun.swing=ALL-UNNAMED" \
      --add-flags "--add-opens java.management/sun.management=ALL-UNNAMED" \
      --add-flags "--add-opens jdk.attach/sun.tools.attach=ALL-UNNAMED" \
      --add-flags "--add-opens jdk.compiler/com.sun.tools.javac.api=ALL-UNNAMED" \
      --add-flags "--add-opens jdk.internal.jvmstat/sun.jvmstat.monitor=ALL-UNNAMED" \
      --add-flags "--add-opens jdk.jdi/com.sun.tools.jdi=ALL-UNNAMED" \
      --add-flags "--enable-native-access=ALL-UNNAMED" \
      --add-flags "-Djdk.lang.Process.launchMechanism=FORK" \
      --add-flags "-cp \"$out/libexec/kotlin-lsp/lib/*\" com.jetbrains.ls.kotlinLsp.KotlinLspServerKt"

    runHook postInstall
  '';

  meta = {
    description = "Kotlin Language Server (Standalone Binary)";
    homepage = "https://github.com/Kotlin/kotlin-lsp";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
