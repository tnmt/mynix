{ inputs }:
[
  inputs.nix-claude-code.overlays.default
  (final: _prev: {
    inherit (inputs.nix-steipete-tools.packages.${final.stdenv.hostPlatform.system}) gogcli;

    # msgvault は TUI/CLI の時刻表示が DB 格納値 (UTC) のままなので、
    # 人間向け表示箇所にだけ .Local() を挟んでシステム TZ (JST) 表示にする。
    msgvault =
      (import inputs.nur-tnmt {
        pkgs = final;
        bun2nix = inputs.bun2nix.packages.${final.stdenv.hostPlatform.system}.default;
      }).msgvault.overrideAttrs
        (old: {
          postPatch = ''
            ${old.postPatch or ""}
            substituteInPlace internal/tui/view.go internal/tui/text_view.go \
              --replace-fail 'msg.SentAt.Format("2006-01-02 15:04")' 'msg.SentAt.Local().Format("2006-01-02 15:04")'
            substituteInPlace internal/tui/view.go \
              --replace-fail 'msg.SentAt.Format("Mon, 02 Jan 2006 15:04:05 MST")' 'msg.SentAt.Local().Format("Mon, 02 Jan 2006 15:04:05 MST")'
            substituteInPlace cmd/msgvault/cmd/search.go \
              --replace-fail 'msg.SentAt.Format("2006-01-02")' 'msg.SentAt.Local().Format("2006-01-02")'
            substituteInPlace cmd/msgvault/cmd/search_vector.go \
              --replace-fail 'r.SentAt.Format("2006-01-02")' 'r.SentAt.Local().Format("2006-01-02")'
            substituteInPlace cmd/msgvault/cmd/show_message.go \
              --replace-fail 'msg.SentAt.Format(time.RFC1123)' 'msg.SentAt.Local().Format(time.RFC1123)'
          '';
        });
  })
  (
    final: prev:
    let
      nurPackages = import inputs.nur-tnmt { pkgs = final; };
    in
    {
      inherit (nurPackages)
        ax
        brave-origin
        ccpocket-bridge
        givy
        kagiana
        mdhq
        oneaws
        roots
        symbol-desktop-wallet
        ;
      chatgpt-linux = nurPackages.chatgpt;
      tokyonight-gtk-theme = prev.tokyonight-gtk-theme.override {
        tweakVariants = [ "storm" ];
        colorVariants = [ "dark" ];
        iconVariants = [ "Dark" ];
      };
      tmux = prev.tmux.overrideAttrs (old: {
        configureFlags =
          (old.configureFlags or [ ])
          ++ final.lib.optionals final.stdenv.hostPlatform.isDarwin [
            "--disable-jemalloc"
          ];
      });
    }
  )
]
