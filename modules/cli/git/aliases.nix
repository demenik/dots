{
  pkgs,
  lib,
  ...
}: {
  programs.git.settings.alias = {
    st = "status -sb";
    sw = "switch";
    swc = ''!f() { remote=\''${2:-origin}; git fetch "$remote" "$1" && git switch -c "$1" "$remote/$1"; }; f'';
    br = "branch";
    cm = "commit -m";

    amend = "commit --amend --no-edit";
    uncommit = "reset --soft HEAD~1";
    fix = ''!f() { git commit --fixup "$1" && git rebase -i --autosquash "$1"~1; }; f'';

    lg = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all";
    search = "!git log -S";

    purge = ''! : git branch ; git branch --merged | egrep -v "(^\*|master|main|dev)" | xargs -r git branch -d'';

    swi =
      "!"
      + lib.getExe (pkgs.writeShellApplication {
        name = "git-swi";
        runtimeInputs = with pkgs; [git ripgrep fzf gnused];
        text = ''
          branch=$(git branch --all | rg -v HEAD | fzf --height 40% --reverse --prompt="Switch to branch: " | sed "s/.* //" | sed "s#remotes/[^/]*/##")
          if [ -n "$branch" ]; then
            git switch "$branch"
          fi
        '';
      });

    spick =
      "!"
      + lib.getExe (pkgs.writeShellApplication {
        name = "git-spick";
        runtimeInputs = with pkgs; [git fzf];
        text = ''
          selected=$(git stash list --color=always | fzf --ansi --reverse --height 50% --prompt "Apply stash: " \
            --preview "git stash show --color=always -p \$(echo {} | cut -d: -f1)")
          stash_id=$(echo "$selected" | cut -d: -f1)
          if [ -n "$stash_id" ]; then
            git stash apply "$stash_id"
          fi
        '';
      });
  };
}
