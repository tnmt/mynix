{
  username,
  ...
}:
let
  services = import ../../modules/nixos/services;
  pubkeys = import ../../modules/common/ssh-pubkeys.nix;
in
{
  # hyprland: nixos-unstable の現行チャンネル (2026-08-04 時点, e72e4f299401) では
  # glaze 依存が壊れており、CMake の FetchContent がサンドボックス内のネットワーク
  # アクセス不可で失敗しビルドできない。修正 (NixOS/nixpkgs#549253) は 2026-08-05 に
  # master へ merge 済みだが、まだ nixos-unstable チャンネルには昇格していない。
  # チャンネルが追いつくまでの間、hyprland だけ修正後のコミットから個別取得する。
  # `nix flake update` で hyprland が正常ビルドされるようになったら削除してよい。
  nixpkgs.overlays = [
    (_final: prev: {
      hyprland =
        let
          fixedPkgs = import (prev.fetchFromGitHub {
            owner = "NixOS";
            repo = "nixpkgs";
            rev = "266bfbbe1512c1eb671ae9ec8ae85a5a25039a0b";
            hash = "sha256-wKPUiiTxPJBRiRQFCOq2wQ2ccl1YFUgM89U1BeJ0KIk=";
          }) { inherit (prev) system; };
        in
        fixedPkgs.hyprland;
    })
  ];

  imports = [
    ./hardware.nix
    ./disko.nix
    ./network.nix

    ../../modules/nixos/core
    services.openssh
    services.ccpocket-bridge
    ../../modules/programs/virtualisation.nix
    ../../modules/hardware/power-management.nix
    ../../profiles/nixos/desktop-hyprland.nix
    ../../profiles/nixos/givy.nix
    ../../profiles/nixos/netbird.nix
    ../../modules/hardware/kanata.nix
  ];

  system.stateVersion = "25.05";

  mynix.profiles = {
    # Host-local networking and access. NetBird is the sole mesh; peers
    # are addressed as `<peer>.netbird.selfhosted` (or just `<peer>` via
    # the NetBird search domain added by modules/nixos/core/netbird.nix).
    netbird.enable = true;

    givy = {
      enable = true;
      instances.github = {
        root = "/home/${username}/ghq/github.com";
        port = 6271;
      };
      trustedRootCAFile = ./caddy-local-ca.crt;
    };

    userTemplates = {
      enable = true;
      voiceInput = true;
      sshPrivate = {
        role = "client";
        tier = "laptop";
      };
      tnmtInfo = true;
    };
  };

  # Dropbox LANSync: TCP=peer転送, UDP=ブロードキャスト発見
  networking.firewall = {
    allowedTCPPorts = [ 17500 ];
    allowedUDPPorts = [ 17500 ];
  };

  # Protonmail Bridge (127.0.0.1:1143 STARTTLS) の自己署名 CA。
  # msgvault 等が daemon 経由でシステム CA ストアを見るため、
  # 個別に SSL_CERT_FILE を渡さずに済むよう system-wide で信頼させる。
  security.pki.certificateFiles = [ ./protonmail-bridge-ca.crt ];

  users.users."${username}" = {
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
    ];
    linger = true;
    # Declarative authorized_keys. Lives at /etc/ssh/authorized_keys.d/<user>;
    # the manual ~/.ssh/authorized_keys is still read by sshd until removed,
    # so it is safe to roll this out before cleaning up the manual file.
    openssh.authorizedKeys.keys = with pubkeys; [
      hosts.work_mac
      hosts.sunflower_wsl
      hosts.hydrangea
      mobile.moshiAndroid
      mobile.zfold7SshTerm
      mobile.iphone13miniSshTerm
    ];
  };

  home-manager.users."${username}" = import ./home-manager.nix;
}
