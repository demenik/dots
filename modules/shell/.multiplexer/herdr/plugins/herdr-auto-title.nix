{
  home = {
    lib,
    pkgs,
    ...
  }: let
    version = "0.4.0";

    src = pkgs.fetchFromGitHub {
      owner = "kryptamine";
      repo = "herdr-auto-title";
      rev = "v${version}";
      hash = "sha256-8InVHoi/uWLaUrmud5yzE+P99ik4tVQxseolNkVjt+g=";
    };

    bin = pkgs.buildGoModule {
      pname = "herdr-auto-title";
      inherit version src;
      vendorHash = "sha256-QxFp1b7pf7bn3Hh0hyaj8ke5Z61N+WwjhHt3pFiapTs=";
      subPackages = ["cmd/herdr-auto-title"];
    };

    settings = {
      HERDR_AUTO_TITLE_MAX_LENGTH = 24;
    };
  in {
    programs.herdr.plugins = [
      {
        package = pkgs.runCommand "herdr-auto-title-${version}" {} ''
          cp -r "${src}" "$out"
          chmod -R u+w "$out"
          install -Dm755 "${bin}"/bin/herdr-auto-title "$out"/herdr-auto-title
        '';

        configFiles."herdr-auto-title/config.env".text = lib.concatStringsSep "\n" (
          lib.mapAttrsToList (k: v: "${k}=${
            if lib.isBool v
            then lib.boolToString v
            else toString v
          }")
          settings
        );
      }
    ];
  };
}
