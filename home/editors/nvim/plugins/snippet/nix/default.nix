{
  flake = {
    template = builtins.readFile ./flake.nix;
    placeholders = {
      "0" = null;
    };
  };
  flaketauri.template = builtins.readFile ./tauri.flake.nix;
  flakeflutter.template = builtins.readFile ./flutter.flake.nix;
  flakeags = {
    template = builtins.readFile ./ags.flake.nix;
    placeholders = {
      "1" = "project-name";
      "2" = "0.1.0";
      "3" = "main.tsx";
      "0" = null;
    };
  };
  flakerust = {
    template = builtins.readFile ./rust.flake.nix;
    placeholders = {
      "1" = "rust-app";
      "2" = "0.1.0";
      "3" = "A Rust application";
      "0" = null;
    };
  };
  flakebevy = {
    template = builtins.readFile ./bevy.flake.nix;
    placeholders = {
      "1" = "bevy-app";
      "2" = "0.1.0";
      "3" = "A Bevy application";
    };
  };
  flakemaven = {
    template = builtins.readFile ./maven.flake.nix;
    placeholders."0" = "25";
  };
  flakegradle = {
    template = builtins.readFile ./gradle.flake.nix;
    placeholders."0" = "25";
  };
  flakenpm = {
    template = builtins.readFile ./npm.flake.nix;
    placeholders = {
      "1" = "npm-app";
      "2" = "0.1.0";
      "0" = null;
    };
  };
  flakeshell = {
    template = builtins.readFile ./shell.flake.nix;
    placeholders."0" = null;
  };
}
