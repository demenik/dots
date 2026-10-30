{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          android_sdk.accept_license = true;
        };
      };

      buildToolsVersion = "<1>";
      platformVersion = "<2>";
      pinnedJdk = pkgs.jdk<4>_headless;

      mkAndroidSdk = extra:
        (pkgs.androidenv.composeAndroidPackages ({
            buildToolsVersions = [buildToolsVersion];
            platformVersions = [platformVersion];
            includeCmake = false;
          }
          // extra))
        .androidsdk;

      mkAndroidShell = androidSdk: extraPackages:
        pkgs.mkShell rec {
          packages = [pinnedJdk androidSdk pkgs.gradle_9] ++ extraPackages;

          JAVA_HOME = pinnedJdk.home;
          ANDROID_HOME = "${androidSdk}/libexec/android-sdk";
          ANDROID_SDK_ROOT = ANDROID_HOME;

          GRADLE_OPTS = pkgs.lib.concatStringsSep " " [
            "-Dorg.gradle.java.installations.auto-download=false"
            "-Dorg.gradle.java.installations.paths=${pinnedJdk.home}"
            "-Dorg.gradle.project.android.aapt2FromMavenOverride=${ANDROID_HOME}/build-tools/${buildToolsVersion}/aapt2"
          ];
        };
    in {
      devShells.default = mkAndroidShell (mkAndroidSdk {}) (with pkgs; [<0>]);

      devShells.emulator = mkAndroidShell (mkAndroidSdk {
        platformVersions = [platformVersion "<5>"];
        includeEmulator = true;
        includeSystemImages = true;
        systemImageTypes = ["<6>" "google_apis"];
        abiVersions = ["<3>"];
      }) [];
    });
}
