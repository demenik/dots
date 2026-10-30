{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.librewolf.extensionStorage;
  profileDir = "${config.home.homeDirectory}/${config.programs.librewolf.profilesPath}/${config.programs.librewolf.profiles.default.path}";

  firefoxAddons = pkgs.callPackage inputs.firefox-addons {
    buildMozillaXpiAddon = (import "${inputs.firefox-addons}/../../lib/mozilla.nix" {inherit lib;}).mkBuildMozillaXpiAddon {
      inherit (pkgs) fetchurl stdenv;
    };
  };

  storageFiles =
    lib.mapAttrs (
      id: settings:
        pkgs.writeText
        "librewolf-storage-${lib.strings.sanitizeDerivationName id}.json"
        (builtins.toJSON settings)
    )
    cfg;
in {
  imports = [
    ./bitwarden
    ./canvasblocker.nix
    ./cookie-auto-decline.nix
    ./languagetool.nix
    ./pywalfox.nix
    ./sidebery.nix
    ./theme-vars
    ./ublock-origin.nix
  ];

  options.librewolf.extensionStorage = lib.mkOption {
    type = with lib.types; attrsOf (attrsOf (pkgs.formats.json {}).type);
    default = {};
    description = ''
      storage.local values per extension ID. Unlike home-manager's
      `extensions.settings`, these are deep-merged into the existing storage.js
      on activation, so runtime state (caches, tab trees, site lists) survives.
    '';
  };

  config = {
    _module.args.firefoxAddons = firefoxAddons;

    programs.librewolf.profiles.default.extensions.packages = with firefoxAddons; [
      betterttv
      darkreader
      react-devtools
      return-youtube-dislikes
      sponsorblock
      stylus
      tampermonkey

      (buildFirefoxXpiAddon {
        pname = "auto-resume-downloads";
        version = "1.0.4resigned1";
        addonId = "{07a7e965-fa95-4c07-bc5e-b53930b002bb}";
        url = "https://addons.mozilla.org/firefox/downloads/file/4273658/auto_resume_downloads-1.0.4resigned1.xpi";
        sha256 = "1gb4zi14as13vbgrf2d79d7jjc50nb4dydlb0z2646azkrv1l347";
        meta = {};
      })
      (buildFirefoxXpiAddon {
        pname = "jsonview";
        version = "3.2.0";
        addonId = "jsonview@brh.numbera.com";
        url = "https://addons.mozilla.org/firefox/downloads/file/4494774/jsonview-3.2.0.xpi";
        sha256 = "0hlrr914fxbw660dym5y874iswbplxrgs54cb7yyh5jyivhb9zqg";
        meta = {};
      })
      (buildFirefoxXpiAddon {
        pname = "leetify";
        version = "1.0.7";
        addonId = "leetify@leetify";
        url = "https://addons.mozilla.org/firefox/downloads/file/5070955/leetify-1.0.7.xpi";
        sha256 = "095fkqxmhs78nc20c8zp18v6364a49ypyb4yfaip2x456fn8654k";
        meta = {};
      })
      (buildFirefoxXpiAddon {
        pname = "markdown-viewer-webext";
        version = "1.8.1";
        addonId = "{943b8007-a895-44af-a672-4f4ea548c95f}";
        url = "https://addons.mozilla.org/firefox/downloads/file/3894829/markdown_viewer_webext-1.8.1.xpi";
        sha256 = "0nfr540p92ljdil5h1n5j8rmwrrv7vz92b970qbcg5jxlnln36zw";
        meta = {};
      })
      (buildFirefoxXpiAddon {
        pname = "oii";
        version = "2025.11.1";
        addonId = "{e844d8ad-7f10-4de7-ad36-13c95d10aae4}";
        url = "https://addons.mozilla.org/firefox/downloads/file/4885919/oii-2025.11.1.xpi";
        sha256 = "0arm8cbxmdpg700agxg5nrnzhjjlqxgsvq05w6bacx1jpygmmj76";
        meta = {};
      })
    ];

    programs.librewolf.profiles.default.settings = {
      # Use storage.js instead of IndexedDB so storage.local can be managed
      "extensions.webextensions.ExtensionStorageIDB.enabled" = false;

      # Enable nix-provided addons and keep them from self-updating
      "extensions.autoDisableScopes" = 0;
      "extensions.update.enabled" = false;
      "extensions.update.autoUpdateDefault" = false;
    };

    home.activation.librewolfExtensionStorage = lib.mkIf (cfg != {}) (lib.hm.dag.entryAfter ["writeBoundary"]
      # sh
      ''
        # The browser rewrites storage.js from memory, so merging while it runs is lost
        if ${lib.getExe' pkgs.procps "pgrep"} -u "$(id -u)" -f '/(bin|lib/librewolf)/librewolf( |$)' >/dev/null; then
          warnEcho "LibreWolf is running, skipping extension storage merge. Close it and re-run activation."
        elif [[ -v DRY_RUN ]]; then
          verboseEcho "Would merge LibreWolf extension storage"
        else
          ${lib.concatStrings (lib.mapAttrsToList (
            id: file:
            # sh
            ''
              dir=${lib.escapeShellArg "${profileDir}/browser-extension-data/${id}"}
              mkdir -p "$dir"
              if [ -s "$dir/storage.js" ]; then
                ${lib.getExe pkgs.jq} -s '.[0] * .[1]' "$dir/storage.js" ${file} > "$dir/storage.js.tmp"
              else
                install -m644 ${file} "$dir/storage.js.tmp"
              fi
              mv "$dir/storage.js.tmp" "$dir/storage.js"
            ''
          )
          storageFiles)}
        fi
      '');
  };
}
