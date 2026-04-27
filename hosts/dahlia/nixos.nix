{
  username,
  ...
}:
let
  services = import ../../modules/services;
  pubkeys = import ../../modules/common/ssh-pubkeys.nix;
in
{
  imports = [
    ./hardware.nix
    ./disko.nix

    # Shared system roles.
    ../../modules/nixos/core
    services."openssh"
    services."ccpocket-bridge"
    ../../modules/programs/virtualisation.nix
    ../../modules/hardware/power-management.nix
    ../../profiles/nixos/desktop-hyprland.nix
    ../../profiles/nixos/homelab-wifi-static.nix
    ../../modules/hardware/kanata.nix
  ];

  # Use host SSH key for sops; avoids /home dependency at boot time.
  sops.age.keyFile = null;
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  # Host-local networking and access.
  services.tailscale.enable = true;

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
