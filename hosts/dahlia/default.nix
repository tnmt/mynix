{
  username,
  ...
}:
let
  services = import ../../modules/nixos/services;
  pubkeys = import ../../modules/common/ssh-pubkeys.nix;
in
{
  imports = [
    ./hardware.nix
    ./disko.nix
    ./network.nix

    # Shared system roles.
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
      hosts.sunflower
      hosts.hydrangea
      mobile.zfold7SshTerm
      mobile.iphone13miniSshTerm
    ];
  };

  # Host-specific Home Manager entrypoint.
  home-manager.users."${username}" = import ./home-manager.nix;
}
