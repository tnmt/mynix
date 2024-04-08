{ pkgs
, ...
}: {
  programs.git = {
    enable = true;
    userName = "tnmt";
    userEmail = "s@tnmt.info";
    extraConfig = {
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

    };

    includes = [
      { path = "~/.gitconfig.default"; }
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

  home.packages = with pkgs; [
    git-trim
  ];
}
