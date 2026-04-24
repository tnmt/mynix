{
  ...
}:
{
  imports = [
    # Shared WSL-oriented Home Manager profile.
    ../../profiles/home-manager/wsl.nix
  ];

  # WSL は systemd user unit が使いづらい → keychain で ssh-agent を
  # シェル跨ぎ共有。colmena デプロイ時の再入力を避ける目的。
  programs.keychain = {
    enable = true;
    keys = [ "id_ed25519" ];
    extraFlags = [ "--quiet" ];
  };
}
