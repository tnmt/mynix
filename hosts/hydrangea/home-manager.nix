{ ... }:
{
  imports = [
    # Shared darwin user profile for development hosts.
    ../../profiles/home-manager/darwin-development.nix
  ];

  # direnv 2.37.1 の checkPhase (zsh test) が aarch64-darwin でハング。
  # Hydra キャッシュ未生成 → ローカルビルドで詰まる。doCheck 無効化で回避。
  nixpkgs.overlays = [
    (_final: prev: {
      direnv = prev.direnv.overrideAttrs (_: {
        doCheck = false;
      });
    })
  ];
}
