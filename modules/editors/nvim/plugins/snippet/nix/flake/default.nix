{
  programs.nixvim.snippets.nix = {
    flake = {
      template = builtins.readFile ./flake.nix;
      placeholders."0" = null;
    };
    flaketauri.template = builtins.readFile ./flake-tauri.nix;
    flakeflutter.template = builtins.readFile ./flake-flutter.nix;
    flakeags = {
      template = builtins.readFile ./flake-ags.nix;
      placeholders = {
        "1" = "project-name";
        "2" = "0.1.0";
        "3" = "main.tsx";
        "0" = null;
      };
    };
    flakerust = {
      template = builtins.readFile ./flake-rust.nix;
      placeholders = {
        "1" = "rust-app";
        "2" = "0.1.0";
        "3" = "A Rust application";
        "0" = null;
      };
    };
    flakebevy = {
      template = builtins.readFile ./flake-bevy.nix;
      placeholders = {
        "1" = "bevy-app";
        "2" = "0.1.0";
        "3" = "A Bevy application";
      };
    };
    flakemaven = {
      template = builtins.readFile ./flake-maven.nix;
      placeholders."0" = "25";
    };
    flakegradle = {
      template = builtins.readFile ./flake-gradle.nix;
      placeholders."0" = "25";
    };
    flakenpm = {
      template = builtins.readFile ./flake-npm.nix;
      placeholders = {
        "1" = "npm-app";
        "2" = "0.1.0";
        "0" = null;
      };
    };
    flakeshell = {
      template = builtins.readFile ./flake-shell.nix;
      placeholders."0" = null;
    };
    flakebun = {
      template = builtins.readFile ./flake-bun.nix;
      placeholders."0" = null;
    };
    flakepnpm = {
      template = builtins.readFile ./flake-pnpm.nix;
      placeholders."0" = null;
    };
    "flakec#" = {
      template = builtins.readFile ./flake-csharp.nix;
      placeholders."0" = null;
    };
    flakego = {
      template = builtins.readFile ./flake-go.nix;
      placeholders."0" = null;
    };
    flakeandroid = {
      template = builtins.readFile ./flake-android.nix;
      placeholders = {
        "1" = "36.0.0";
        "2" = "36";
        "3" = "armeabi-v8a";
        "4" = "21";
        "0" = null;
      };
    };

    shellandroid = {
      template = builtins.readFile ./shell-android.nix;
      placeholders = {
        "1" = "36.0.0";
        "2" = "36";
        "3" = "armeabi-v8a";
        "4" = "21";
        "0" = null;
      };
    };
  };
}
