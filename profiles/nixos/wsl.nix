# Shared WSL system profile for NixOS hosts running inside Windows.
{
  config,
  inputs,
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
    defaultSopsFile = ../../secrets/default.yaml;
    age.keyFile = "${homeDir}/.config/sops/age/keys.txt";
    secrets = {
      git_email.owner = username;
      git_name.owner = username;
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
}
