{pkgs, ...}: {
  home.packages = [
    (pkgs.writeShellApplication {
      name = "review";
      runtimeInputs = with pkgs; [git];
      text = ''
        CURRENT_BRANCH=$(git branch --show-current)

        if [ "$CURRENT_BRANCH" = "main" ]; then
          echo "Error: Review on branch 'main' is not possible."
          exit 1
        elif [ "$CURRENT_BRANCH" = "dev" ]; then
          BASE="main"
        else
          BASE="dev"
        fi

        nvim -c "DiffviewOpen $BASE"
      '';
    })
  ];

  programs.nixvim = {
    plugins = {
      diffview = {
        enable = true;
        package = pkgs.vimUtils.buildVimPlugin {
          pname = "diffview.nvim";
          version = "latest";
          src = pkgs.fetchFromGitHub {
            owner = "dlyongemallo";
            repo = "diffview.nvim";
            rev = "main";
            hash = "sha256-14JZDPF/BYbdY3EWAC509AU4amw5FnV7r0u28vvxJAY=";
          };
          doCheck = false;
        };
      };
    };
  };
}
