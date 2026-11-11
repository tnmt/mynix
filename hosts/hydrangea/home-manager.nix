{ ... }:
{
  imports = [
    ../../profiles/home-manager/darwin-development.nix
    ../../profiles/home-manager/ssh-agent-keychain.nix
  ];

  # macOS ではログインセッションに launchd の ssh-agent (鍵なし) の SSH_AUTH_SOCK が
  # 入っており、既存シェルには 1Password agent の値も残りうる。keychain が
  # それらを継承して pidfile に書くと agent がセッションごとに分かれるため、
  # 常に ~/.keychain 配下の自前 agent を使わせる。
  programs.keychain.extraFlags = [ "--no-inherit" ];

  # direnv 2.37.1 の checkPhase (zsh test) が aarch64-darwin でハング。
  # Hydra キャッシュ未生成 → ローカルビルドで詰まる。doCheck 無効化で回避。
  nixpkgs.overlays = [
    (_final: prev: {
      direnv = prev.direnv.overrideAttrs (_: {
        doCheck = false;
      });
      # atuin 18.24.4 の e2e_ai_sessions (Agent::Pi ケース 2 件) が darwin で失敗する。
      # キャッシュ未生成でローカルビルドになり、checkPhase で switch が止まる。
      atuin = prev.atuin.overrideAttrs (_: {
        doCheck = false;
      });
    })
  ];
}
