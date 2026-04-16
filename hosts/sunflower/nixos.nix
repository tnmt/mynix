{
  config,
  inputs,
  lib,
  pkgs,
  username,
  ...
}:
let
  homeDir = "/home/${username}";
in
{
  imports = [
    ../../modules/core
    ../../modules/services/openssh.nix

    inputs.nixos-wsl.nixosModules.default
  ];

  fileSystems."/" = {
    device = "/dev/sdd";
    fsType = "ext4";
  };

  nix.settings.secret-key-files = "/etc/remotebuild/cache-priv-key.pem";

  wsl.defaultUser = "${username}";

  services.openssh.ports = [ 2222 ];

  # System-level sops (WSL has no user systemd, so home-manager sops doesn't work)
  sops = {
    defaultSopsFile = ../../secrets/default.yaml;
    age.keyFile = "${homeDir}/.config/sops/age/keys.txt";
    secrets = {
      git_email = {
        owner = username;
      };
      git_name = {
        owner = username;
      };
      atuin_sync_address = {
        sopsFile = ../../secrets/common.yaml;
        owner = username;
      };
    };
    templates."git-identity" = {
      owner = username;
      content = ''
        [user]
          email = ${config.sops.placeholder.git_email}
          name = ${config.sops.placeholder.git_name}
      '';
    };
    templates."atuin-config" = {
      owner = username;
      content = ''
        auto_sync = true
        sync_frequency = "20m"
        search_mode = "fuzzy"
        filter_mode = "global"
        inline_height = 20
        enter_accept = false
        sync_address = "${config.sops.placeholder.atuin_sync_address}"
      '';
    };
  };

  # Link sops templates into user config dirs
  systemd.services.sops-link-user-configs = {
    description = "Symlink sops templates into user XDG config";
    after = [ "sops-nix.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      User = username;
      RemainAfterExit = true;
    };
    script = ''
      mkdir -p ${homeDir}/.config/git ${homeDir}/.config/atuin
      ln -sf ${config.sops.templates."git-identity".path} ${homeDir}/.config/git/identity
      ln -sf ${config.sops.templates."atuin-config".path} ${homeDir}/.config/atuin/config.toml
    '';
  };

  # CC Pocket Bridge Server
  systemd.services.ccpocket-bridge = {
    description = "CC Pocket Bridge Server";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
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
