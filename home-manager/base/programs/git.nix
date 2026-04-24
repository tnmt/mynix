{
  config,
  pkgs,
  theme,
  ...
}:
let
  themeSrc = pkgs.fetchFromGitHub theme.src;
  sopsShared = import ../../../profiles/common/sops-shared.nix;
in
{
  programs.git = {
    enable = true;

    includes = [
      { path = "~/.config/git/identity"; }
      {
        path = "~/.config/git/personal-identity";
        condition = "gitdir:~/ghq/github.com/";
      }
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

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      syntax-theme = theme.delta;
    };
  };

  programs.gitui = {
    enable = true;
    theme = builtins.readFile "${themeSrc}/${theme.extras.gitui}";
  };

  home.packages = with pkgs; [ git-trim ];

  sops.templates."git-identity" = {
    content = sopsShared.mkGitIdentityTemplate {
      emailPlaceholder = config.sops.placeholder.git_email;
      namePlaceholder = config.sops.placeholder.git_name;
    };
    path = "${config.xdg.configHome}/git/identity";
  };

  sops.templates."git-personal-identity" = {
    content = sopsShared.mkGitIdentityTemplate {
      emailPlaceholder = config.sops.placeholder.git_personal_email;
      namePlaceholder = config.sops.placeholder.git_personal_name;
    };
    path = "${config.xdg.configHome}/git/personal-identity";
  };
}
