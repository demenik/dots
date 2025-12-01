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

      buildToolsVersion = "35.0.0";
      androidComposition = pkgs.androidenv.composeAndroidPackages {
        buildToolsVersions = [buildToolsVersion "28.0.3"];
        platformVersions = ["36" "28"];
        abiVersions = ["armeabi-v7a" "arm64-v8a"];
        includeNDK = true;
        ndkVersions = ["27.0.12077973"];
        cmakeVersions = ["3.22.1"];
      };
      androidSdk = androidComposition.androidsdk;
      jdk = pkgs.jdk17;
    in {
      devShells.default = pkgs.mkShell rec {
        buildImports = with pkgs; [
          flutter
          androidSdk
          jdk
        ];

        ANDROID_SDK_ROOT = "${androidSdk}/libexec/android-sdk";
        ANDROID_NDK_ROOT = "${ANDROID_SDK_ROOT}/ndk-bundle";

        GRADLE_OPTS = "-Dorg.gradle.project.android.aapt2FromMavenOverride=${ANDROID_SDK_ROOT}/build-tools/${buildToolsVersion}/aapt2";
      };
    });
}
