{ pkgs, ... }:
{
  programs.git = {
    enable = true;

    includes = [
      { path = "~/.gitconfig.default"; }
    ];

    extraConfig = {
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
    ];


    aliases = {
      co = "checkout";
      ci = "commit";
      di = "diff";
      st = "status";
      up = "pull --rebase";
    };
  };

  programs.gitui = {
    enable = true;
  };

  home.packages = with pkgs; [ git-trim ];
}
