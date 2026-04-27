#
# Shared helpers for sops-backed user config fragments.
# WSL reuses the same secret names and rendered template bodies, but keeps
# ownership and placement at the NixOS layer because user systemd is absent.
#
let
  mkOwnedSecrets =
    owner: secrets: builtins.mapAttrs (_: secret: secret // { inherit owner; }) secrets;

  mkCoreSecrets =
    {
      commonSopsFile,
      gitSopsFile,
    }:
    {
      git_email = {
        sopsFile = gitSopsFile;
      };
      git_name = {
        sopsFile = gitSopsFile;
      };
      atuin_sync_address = {
        sopsFile = commonSopsFile;
      };
    };

  mkPersonalGitSecrets =
    { personalSopsFile }:
    {
      git_personal_email = {
        sopsFile = personalSopsFile;
        key = "git_email";
      };
      git_personal_name = {
        sopsFile = personalSopsFile;
        key = "git_name";
      };
    };

  mkSshPrivateSecrets =
    { personalSopsFile }:
    {
      lan_prefix = {
        sopsFile = personalSopsFile;
        key = "lan_prefix";
      };
      vps01_host = {
        sopsFile = personalSopsFile;
        key = "vps01_host";
      };
    };

  mkGitIdentityTemplate =
    {
      emailPlaceholder,
      namePlaceholder,
    }:
    ''
      [user]
        email = ${emailPlaceholder}
        name = ${namePlaceholder}
    '';

  mkAtuinConfigTemplate =
    { syncAddressPlaceholder }:
    ''
      auto_sync = true
      sync_frequency = "20m"
      search_mode = "fuzzy"
      filter_mode = "global"
      inline_height = 20
      enter_accept = false
      sync_address = "${syncAddressPlaceholder}"
    '';

  mkSshPrivateTemplate =
    {
      lanPrefixPlaceholder,
      vps01HostPlaceholder,
      tier,
      includeTailscale ? true,
    }:
    import ./ssh-private-content.nix {
      lanPrefix = lanPrefixPlaceholder;
      vps01Host = vps01HostPlaceholder;
      inherit tier includeTailscale;
    };
in
{
  inherit
    mkAtuinConfigTemplate
    mkCoreSecrets
    mkGitIdentityTemplate
    mkOwnedSecrets
    mkPersonalGitSecrets
    mkSshPrivateSecrets
    mkSshPrivateTemplate
    ;
}
