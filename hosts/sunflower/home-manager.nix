{
  ...
}:
{
  imports = [
    # Shared WSL-oriented Home Manager profile.
    ../../profiles/home-manager/wsl.nix
  ];

  # sunflower = LAN hub. The actual private.config is emitted at the
  # NixOS system level by profiles/nixos/wsl.nix (WSL has no user
  # systemd). This declaration is retained so the option axes stay
  # populated if the home-manager override is ever lifted.
  profiles.sshPrivate = {
    role = "client";
    tier = "workstation";
  };

  # WSL は systemd user unit が使いづらい → keychain で ssh-agent を
  # シェル跨ぎ共有。colmena デプロイ時の再入力を避ける目的。
  programs.keychain = {
    enable = true;
    keys = [ "id_ed25519" ];
    extraFlags = [ "--quiet" ];
  };
}
