{ username, ... }:
let
  pubkeys = import ../../modules/common/ssh-pubkeys.nix;
in
{
  imports = [
    ../../modules/darwin/core

    ../../profiles/darwin/system-common.nix
    ../../profiles/darwin/homebrew-base.nix
  ];

  # hydrangea 固有に手動インストールしていたアプリを移管。
  # motu-m-series は cask はあるが Audio Interface のドライバ pkg で、
  # onActivation.cleanup = "uninstall" の対象にすると誤って剥がれるため見送り。
  # xld は cask はあるが Gatekeeper 非対応で 2026-09-01 付けで disabled 済みのため見送り。
  homebrew = {
    casks = [
      "android-file-transfer"
      "audacity"
      "calibre"
      "iina"
      "vlc"
    ];
    masApps = {
      "1Password for Safari" = 1569813296;
      "Day One" = 1055511498;
      "Habitify" = 1111447047;
      "Kindle" = 302584613;
      "Skitch" = 425955336;
    };
  };

  # Bring the system sshd under nix-darwin so Remote Login stays on
  # and the authorizedKeysCommand drop-in at
  # /etc/ssh/sshd_config.d/101-authorized-keys.conf is installed.
  services.openssh.enable = true;

  users.users."${username}".openssh.authorizedKeys.keys = with pubkeys; [
    hosts.work_mac
  ];

  mynix.profiles.userTemplates = {
    enable = true;
    sshPrivate = {
      role = "client";
      tier = "laptop";
    };
    tnmtInfo = true;
  };

  home-manager.users."${username}" = import ./home-manager.nix;
}
