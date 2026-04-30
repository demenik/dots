{
  pkgs ?
    import <<nixpkgs>> {
      config = {
        allowUnfree = true;
        android_sdk.accept_license = true;
      };
    },
}: let
  androidComposition = pkgs.androidenv.composeAndroidPackages {
    buildToolsVersions = ["<1>"];
    platformVersions = ["<2>"];
    abiVersions = ["<3>"];
  };
  pinnedJdk = pkgs.jdk<4>_headless;
in
  pkgs.mkShell {
    buildInputs = with pkgs; [
      gradle
      pinnedJdk
      androidComposition.androidsdk
      <0>
    ];

    JAVA_HOME = pinnedJdk.home;
    ANDROID_HOME = "${androidComposition.androidsdk}/libexec/android-sdk";
    ANDROID_SDK_ROOT = "${androidComposition.androidsdk}/libexec/android-sdk";

    GRADLE_OPTS = pkgs.lib.concatStringsSep " " [
      "-Dorg.gradle.java.installations.auto-download=false"
      "-Dorg.gradle.project.android.aapt2FromMavenOverride=${pkgs.aapt}/bin/aapt2"
    ];
  }
