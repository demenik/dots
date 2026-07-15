{lib, ...}: {
  programs.librewolf.profiles.default.search = {
    force = true;

    default = "ud";
    order = [
      "ud"
      "xng"

      "np"
      "nur"
      "no"
      "hm"
      "nv"
      "lsp"
      "crates"
      "cat"

      "proton"
    ];

    engines = let
      mkParams = lib.mapAttrsToList (name: value: {
        inherit name value;
      });

      mkEngine = {
        icon,
        template,
        params ? {},
        definedAliases ? [],
      }: {
        inherit icon definedAliases;
        urls = [
          {
            inherit template;
            params = mkParams params;
          }
        ];
      };
    in {
      ud = mkEngine {
        icon = "https://unduck.demenik.dev/search.svg";
        template = "https://unduck.demenik.dev";
        params.q = "{searchTerms}";
      };

      np = mkEngine {
        icon = "https://search.nixos.org/images/nixos-logomark-default-gradient-none.svg";
        definedAliases = ["@np"];
        template = "https://search.nixos.org/packages";
        params = {
          channel = "unstable";
          query = "{searchTerms}";
        };
      };
      nur = mkEngine {
        icon = "https://nur.nix-community.org/images/favicon.png";
        definedAliases = ["@nur"];
        template = "https://nur.nix-community.org";
        params.query = "{searchTerms}";
      };
      no = mkEngine {
        icon = "https://search.nixos.org/images/nixos-logomark-default-gradient-none.svg";
        definedAliases = ["@no"];
        template = "https://search.nixos.org/options";
        params = {
          channel = "unstable";
          query = "{searchTerms}";
        };
      };
      hm = mkEngine {
        icon = "https://home-manager-options.extranix.com/images/favicon.png";
        definedAliases = ["@hm"];
        template = "https://home-manager-options.extranix.com";
        params = {
          release = "master";
          query = "{searchTerms}";
        };
      };

      nv = mkEngine {
        icon = "https://raw.githubusercontent.com/nix-community/nixvim/main/assets/nixvim_logo.svg";
        definedAliases = ["@nv"];
        template = "https://nix-community.github.io/nixvim/";
        params.search = "{searchTerms}";
      };
      lsp = mkEngine {
        icon = "https://github.com/neovim.png";
        definedAliases = ["@lsp"];
        template = "https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#{searchTerms}";
      };
      crates = mkEngine {
        icon = "https://crates.io/_app/immutable/assets/cargo.VCOwdw75.png";
        definedAliases = ["@crates"];
        template = "https://crates.io/search";
        params.q = "{searchTerms}";
      };
      cat = mkEngine {
        icon = "https://catppuccin.com/favicon.png";
        definedAliases = ["@cat"];
        template = "https://catppuccin.com/ports";
        params.q = "{searchTerms}";
      };

      proton = mkEngine {
        icon = "https://head.protondb.pages.dev/sites/protondb/images/favicon.ico";
        definedAliases = ["@proton"];
        template = "https://www.protondb.com/search";
        params.q = "{searchTerms}";
      };
    };
  };
}
