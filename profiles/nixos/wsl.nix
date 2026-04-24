# Shared WSL system profile for NixOS hosts running inside Windows.
{
  config,
  inputs,
  sopsShared,
  username,
  ...
}:
let
  homeDir = "/home/${username}";
in
{
  imports = [
    inputs.nixos-wsl.nixosModules.default
  ];

  wsl.defaultUser = username;

  # WSL has no user systemd, so keep these secrets at the system level.
  sops = {
    defaultSopsFile = ../../secrets/roles/personal.yaml;
    age.keyFile = "${homeDir}/.config/sops/age/keys.txt";
    secrets = sopsShared.mkOwnedSecrets username (
      sopsShared.mkCoreSecrets {
        commonSopsFile = ../../secrets/common.yaml;
      }
      // sopsShared.mkSshPrivateSecrets {
        personalSopsFile = ../../secrets/roles/personal.yaml;
      }
    );
    templates = {
      "ssh-private-config" = {
        owner = username;
        # tier = "workstation" implies "this host is the LAN hub itself",
        # so self-reference sunflower blocks are skipped and LAN peers
        # resolve directly. WSL hosts don't run tailscaled, so Tailscale
        # aliases are omitted. sunflower is currently the only WSL host
        # and also the sole workstation; re-parameterise if that changes.
        content = sopsShared.mkSshPrivateTemplate {
          lanPrefixPlaceholder = config.sops.placeholder.lan_prefix;
          vps01HostPlaceholder = config.sops.placeholder.vps01_host;
          tier = "workstation";
          includeTailscale = false;
        };
      };
      "git-identity" = {
        owner = username;
        content = sopsShared.mkGitIdentityTemplate {
          emailPlaceholder = config.sops.placeholder.git_email;
          namePlaceholder = config.sops.placeholder.git_name;
        };
      };
      "atuin-config" = {
        owner = username;
        content = sopsShared.mkAtuinConfigTemplate {
          syncAddressPlaceholder = config.sops.placeholder.atuin_sync_address;
        };
      };
    };
  };

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
      mkdir -p ${homeDir}/.config/git ${homeDir}/.config/atuin ${homeDir}/.ssh/conf.d
      ln -sf ${config.sops.templates."git-identity".path} ${homeDir}/.config/git/identity
      ln -sf ${config.sops.templates."atuin-config".path} ${homeDir}/.config/atuin/config.toml
      ln -sf ${config.sops.templates."ssh-private-config".path} ${homeDir}/.ssh/conf.d/private.config
    '';
  };
}
