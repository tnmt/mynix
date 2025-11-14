{ pkgs, ... }:
{
  programs.git = {
    enable = true;

    includes = [
      { path = "~/.gitconfig.default"; }
    ];

    settings = {
      core = {
        editor = "nvim";
      };

      push = {
        # remoteに同じbranch名でpushする
        # upstreamの設定を要求しない
        default = "current";
      };

      pull = {
        rebase = true;
      };

      init = {
        defaultBranch = "main";
      };

      color = {
        ui = "auto";
      };

      credential = {
        helper = "cache --timeout=604800";
      };

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
      };
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

  programs.gitui = {
    enable = true;
  };

  home.packages = with pkgs; [ git-trim ];
}
