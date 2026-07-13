{
  pkgs,
  theme,
  ...
}:
let
  themeSrc = pkgs.fetchFromGitHub theme.src;
in
{
  programs = {
    git = {
      enable = true;

      includes = [
        { path = "~/.config/git/identity"; }
        # github.com リモートを持つリポジトリでは user.email を GitHub noreply に上書き。
        # 中身は下の xdg.configFile."git/github-identity" で生成 (公開情報のため平文)。
        {
          path = "~/.config/git/github-identity";
          condition = "hasconfig:remote.*.url:https://github.com/**";
        }
        # scp 形式は ":**" だと wildmatch で不正パターン扱いになるため ":*/**" にする
        {
          path = "~/.config/git/github-identity";
          condition = "hasconfig:remote.*.url:git@github.com:*/**";
        }
        {
          path = "~/.config/git/github-identity";
          condition = "hasconfig:remote.*.url:ssh://git@github.com/**";
        }
        # さらに追加の identity 振り分け (includeIf) が必要な場合は、
        # 利用側 flake の home-manager モジュールで宣言する。
        { path = "${themeSrc}/${theme.extras.delta}"; }
      ];

      settings = {
        push = {
          default = "current";
          autoSetupRemote = true;
        };

        pull.rebase = true;

        init.defaultBranch = "main";

        color.ui = "auto";

        credential.helper = "!gh auth git-credential";

        rebase = {
          autosquash = true;
          autostash = true;
          stat = true;
        };

        alias = {
          co = "checkout";
          ci = "commit";
          di = "diff";
          st = "status";
          up = "pull --rebase";
          br = "branch";
          graph = "log --graph --oneline --decorate --all";
          ls = ''log --pretty=format:"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]" --decorate'';
          ll = ''log --pretty=format:"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]" --decorate --numstat'';
          undo = "reset --soft HEAD^";
          aicommitjp = ''!f() { COMMITMSG=$(claude -p 'Generate ONLY a one-line Git commit message in Japanese. Start with one of these prefixes: feat:, fix:, refactor:, chore:, or docs: based on the type of change. The prefix should be in English, but the rest of the message should be in Japanese. Summarize what was changed and why, based strictly on the contents of `git diff --cached`. Do not add explanation or a body. Output only the commit summary line.'); git commit -m "$COMMITMSG" ; }; f'';
          aicommit = ''!f() { COMMITMSG=$(claude -p 'Generate ONLY a one-line Git commit message in English. Start with one of these prefixes: feat:, fix:, refactor:, chore:, or docs: based on the type of change. Summarize what was changed and why, based strictly on the contents of `git diff --cached`. Do not add explanation or a body. Output only the commit summary line.'); git commit -m "$COMMITMSG" ; }; f'';
        };

        diff = {
          algorithm = "histogram";
          colorMoved = "zebra";
          mnemonicPrefix = true;
        };

        merge.conflictstyle = "diff3";

        commit.verbose = true;

        column.ui = "auto";

        branch.sort = "-committerdate";

        tag.sort = "-version:refname";

        rerere = {
          enabled = true;
          autoupdate = true;
        };

        fetch.prune = true;
      };

      ignores = [
        "*~"
        "*.swp"
        ".DS_Store"
        ".direnv"
        ".env"
        ".envrc"
        ".ruby-version"
        ".go-version"
        ".claude/"
      ];
    };

    delta = {
      enable = true;
      enableGitIntegration = true;
      options = {
        syntax-theme = theme.delta;
      };
    };

    gitui = {
      enable = true;
      theme = builtins.readFile "${themeSrc}/${theme.extras.gitui}";
    };
  };

  xdg.configFile."git/github-identity".text = ''
    [user]
      email = 56112+tnmt@users.noreply.github.com
      signingkey = ~/.ssh/id_ed25519.pub
    [gpg]
      format = ssh
    [commit]
      gpgsign = true
    [tag]
      gpgsign = true
  '';

  home.packages = with pkgs; [
    git-trim
    gitleaks
  ];
  # ~/.config/git/{identity,personal-identity} are rendered at the
  # NixOS/darwin system layer (profiles/common/user-sops.nix) and
  # symlinked into ~/.config/git/.
}
