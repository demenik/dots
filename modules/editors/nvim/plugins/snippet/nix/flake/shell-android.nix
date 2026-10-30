{
  pkgs ?
    import <<nixpkgs>> {
      config = {
        allowUnfree = true;
        android_sdk.accept_license = true;
      };
    },
}: let
  buildToolsVersion = "<1>";
  androidSdk =
    (pkgs.androidenv.composeAndroidPackages {
      buildToolsVersions = [buildToolsVersion];
      platformVersions = ["<2>"];
      abiVersions = ["<3>"];
      includeCmake = false;
    })
    .androidsdk;
  pinnedJdk = pkgs.jdk<4>_headless;
in
  pkgs.mkShell rec {
    buildInputs = with pkgs; [
      gradle_9
      pinnedJdk
      androidSdk
      <0>
    ];

    JAVA_HOME = pinnedJdk.home;
    ANDROID_HOME = "${androidSdk}/libexec/android-sdk";
    ANDROID_SDK_ROOT = ANDROID_HOME;

    GRADLE_OPTS = pkgs.lib.concatStringsSep " " [
      "-Dorg.gradle.java.installations.auto-download=false"
      "-Dorg.gradle.java.installations.paths=${pinnedJdk.home}"
      "-Dorg.gradle.project.android.aapt2FromMavenOverride=${ANDROID_HOME}/build-tools/${buildToolsVersion}/aapt2"
    ];
  }
