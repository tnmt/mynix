{
  inputs,
  lib,
  pkgs,
  username,
  ...
}:
{
  imports = [
    ../../modules/core
    ../../modules/programs/shell.nix
    ../../modules/programs/openssh.nix

    inputs.nixos-wsl.nixosModules.default
  ];

  boot.loader.grub.enable = false;

  fileSystems."/" = {
    device = "/dev/sdd";
    fsType = "ext4";
  };

  nix.settings.secret-key-files = "/etc/remotebuild/cache-priv-key.pem";

  wsl.defaultUser = "${username}";

  # WSL uses Windows networking, no need for NetworkManager or wpa_supplicant
  networking.networkmanager.enable = lib.mkForce false;

  services.openssh.ports = [ 2222 ];

  # CC Pocket Bridge Server
  systemd.services.ccpocket-bridge = {
    description = "CC Pocket Bridge Server";
    after = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      User = username;
      ExecStart = "${pkgs.nodejs_22}/bin/npx @ccpocket/bridge@latest";
      Restart = "on-failure";
      RestartSec = 10;
      Environment = [
        "HOME=/home/${username}"
        "PATH=${pkgs.nodejs_22}/bin:${pkgs.bash}/bin:${pkgs.coreutils}/bin:/etc/profiles/per-user/${username}/bin:/run/current-system/sw/bin"
        "npm_config_cache=/home/${username}/.cache/npm"
      ];
    };
  };

  home-manager.users."${username}" = import ./home-manager.nix;
}
