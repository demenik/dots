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

      androidComposition = pkgs.androidenv.composeAndroidPackages {
        buildToolsVersions = ["<1>"];
        platformVersions = ["<2>"];
        abiVersions = ["<3>"];
      };
      pinnedJdk = pkgs.jdk<4>_headless;
    in {
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          jdk
          androidSdk.androidsdk
          gradle
          <0>
        ];

        JAVA_HOME = pinnedJdk.home;
        ANDROID_HOME = "${androidComposition.androidsdk}/libexec/android-sdk";
        ANDROID_SDK_ROOT = "${androidComposition.androidsdk}/libexec/android-sdk";

        GRADLE_OPTS = pkgs.lib.concatStringsSep " " [
          "-Dorg.gradle.java.installations.auto-download=false"
          "-Dorg.gradle.project.android.aapt2FromMavenOverride=${pkgs.aapt}/bin/aapt2"
        ];
      };
    });
}
