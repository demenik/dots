let
  utils = import ./.utils.nix;
in {
  overlays.home = [
    (final: prev: {
      herdr-auto-title = final.buildGoModule (finalAttrs: {
        pname = "herdr-auto-title";
        version = "0.19.0";

        passthru.fmUpdate = {
          inherit (finalAttrs) version;
          script = utils.latestRelease "kryptamine/herdr-auto-title";
        };

        src = final.fetchFromGitHub {
          owner = "kryptamine";
          repo = "herdr-auto-title";
          rev = "v${finalAttrs.version}";
          hash = "sha256-HfZqth8aFy05KkSPAyWCJKKtAQanVZMrU+6rRVCRgcg=";
        };

        vendorHash = "sha256-QxFp1b7pf7bn3Hh0hyaj8ke5Z61N+WwjhHt3pFiapTs=";
        subPackages = ["cmd/herdr-auto-title"];

        # herdr expects the plugin manifest and binary at the package root
        postInstall = ''
          cp -r "$src"/. "$out"
          chmod -R u+w "$out"
          mv "$out"/bin/herdr-auto-title "$out"/herdr-auto-title
          rmdir "$out"/bin
        '';
      });
    })
  ];

  home = {pkgs, ...}: {
    programs.herdr.plugins = [
      {
        package = pkgs.herdr-auto-title;

        settings.HERDR_AUTO_TITLE_MAX_LENGTH = 24;
        settingsFile = "herdr-auto-title/config.env";
      }
    ];
  };
}
