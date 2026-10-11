{ lib, username, ... }:
{
  services.gnome.gnome-keyring.enable = true;
  programs = {
    seahorse.enable = true;

    # CLI (op) と GUI の連携 (生体認証 / アプリ解錠での signin) には、setgid ラッパーと
    # polkit ポリシーが NixOS 側で必要になるため home.packages ではなくここで有効化する。
    _1password.enable = true;
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = [ username ];
    };
  };

  # gnome-keyring の SSH agent 部分 (gcr-ssh-agent) を無効化する。
  # このユニットは ExecStartPost で systemd --user 既定の SSH_AUTH_SOCK を
  # gcr socket に上書きするため、SSH セッション越しの git がそこに着地し、
  # hyprlock でセッションがロックされると署名要求がハングして固まっていた。
  # SSH agent は keychain (profiles/home-manager/ssh-agent-keychain.nix) に一本化し、
  # gnome-keyring 本体 (secret-service) は protonmail-bridge 等のため残す。
  systemd.user.services.gcr-ssh-agent.enable = lib.mkForce false;
  systemd.user.sockets.gcr-ssh-agent.enable = lib.mkForce false;

  security = {
    polkit.enable = true;
    pam.services = {
      login.enableGnomeKeyring = true;
      greetd.enableGnomeKeyring = true;

      # Without a dedicated PAM service file, swaylock falls back to PAM's
      # "other" policy, which denies all auth and locks out password entry.
      swaylock.text = "auth include login";
    };
  };
}
