{ config, pkgs, ... }:
{
  programs.git = {
    enable = true;

    includes = [
      { path = "~/.config/git/identity"; }
    ];

    settings = {
      core.editor = "nvim";

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
      "**/.claude/settings.local.json"
    ];
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      syntax-theme = "tokyonight_storm";
    };
  };

  programs.gitui.enable = true;

  home.packages = with pkgs; [ git-trim ];

  sops.templates."git-identity" = {
    content = ''
      [user]
        email = ${config.sops.placeholder.git_email}
        name = ${config.sops.placeholder.git_name}
    '';
    path = "${config.xdg.configHome}/git/identity";
  };
}
