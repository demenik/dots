{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (config.home) homeDirectory;
  identityFile = "${homeDirectory}/.ssh/id_agenix";
  pubKeyFile = "${homeDirectory}/.ssh/id_agenix.pub";

  age-secret-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "age-secret";
    src = pkgs.fetchFromGitHub {
      owner = "histrio";
      repo = "age-secret.nvim";
      rev = "9be5fbdac534422dc7d03eccb9d5af96f242e16f";
      hash = "sha256-3RMSaUfZyMq9aNwBrdVIP4Mh80HwIcO7I+YhFOw+NU8=";
    };
  };

  rage-wrapped = pkgs.writeShellScriptBin "rage" ''
    TMP_FILE=$(mktemp)
    cat > "$TMP_FILE"

    is_empty=0
    if [ ! -s "$TMP_FILE" ]; then is_empty=1; fi

    is_decrypt=0
    for arg in "$@"; do
      if [ "$arg" = "-d" ] || [ "$arg" = "--decrypt" ]; then
        is_decrypt=1
        break
      fi
    done

    if [ "$is_empty" -eq 1 ] && [ "$is_decrypt" -eq 1 ]; then
      rm "$TMP_FILE"
      exit 0
    fi

    if [ "$is_decrypt" -eq 0 ]; then
      set -- "$@" -R "${pubKeyFile}"
    fi

    cat "$TMP_FILE" | ${lib.getExe pkgs.rage} "$@"
    EXIT_CODE=$?
    rm "$TMP_FILE"
    exit $EXIT_CODE
  '';
in {
  programs.nixvim = {
    extraPlugins = [age-secret-nvim];
    extraPackages = [rage-wrapped];

    extraConfigLua = ''
      require("age_secret").setup {
        identity = "${identityFile}",
      }
    '';

    plugins.gitsigns.settings = {
      diff_opts.internal = false;
    };
  };

  programs.git = {
    attributes = [
      "*.age diff=age"
    ];
    settings = {
      diff.age.textconv = "${lib.getExe pkgs.rage} -i ${identityFile} -d";
    };
  };
}
