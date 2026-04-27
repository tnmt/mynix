# System-level sops.secrets/templates rendered for the workstation user.
# Replaces the previous home-manager sops module across hosts so that
# decryption only depends on the host SSH key (no per-user age key under
# /home or /Users). OS-specific symlinks into the user's home are handled
# by modules/{nixos,darwin}/core/user-templates-link.nix.
{
  config,
  homeSopsFile,
  lib,
  sopsShared,
  username,
  ...
}:
let
  cfg = config.profiles.userTemplates;
  commonSopsFile = ../../secrets/common.yaml;
  personalSopsFile = ../../secrets/roles/personal.yaml;
in
{
  options.profiles.userTemplates = {
    enable = lib.mkEnableOption "user-owned sops templates rendered at the system layer";

    gitPersonal = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Render git-personal-identity in addition to the active git identity.";
    };

    atuin = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Render atuin config.toml.";
    };

    atuinSync = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Include sync_address from sops in atuin config.toml.
        Set false on hosts without sops keys to render config without
        sync_address (auto_sync = false).
      '';
    };

    voiceInput = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Expose voice_input_openrouter_api_key as a user-owned system secret.";
    };

    sshPrivate = {
      role = lib.mkOption {
        type = lib.types.nullOr (
          lib.types.enum [
            "client"
            "server"
          ]
        );
        default = null;
        description = ''
          "client": render ~/.ssh/conf.d/private.config from the sops template.
          "server": receive-only host — neither secret nor template is created.
          null:    do not configure ssh-private at all.
        '';
      };
      tier = lib.mkOption {
        type = lib.types.nullOr (
          lib.types.enum [
            "laptop"
            "workstation"
          ]
        );
        default = null;
        description = ''Required when role = "client".'';
      };
      includeTailscale = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Include Tailscale -ts host aliases (requires MagicDNS on this host).";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.sshPrivate.role != "client" || cfg.sshPrivate.tier != null;
        message = ''profiles.userTemplates.sshPrivate.tier must be set when role = "client"'';
      }
    ];

    sops.secrets = sopsShared.mkOwnedSecrets username (
      sopsShared.mkCoreSecrets {
        inherit commonSopsFile;
        gitSopsFile = homeSopsFile;
        includeAtuinSync = cfg.atuin && cfg.atuinSync;
      }
      // (lib.optionalAttrs cfg.gitPersonal (
        sopsShared.mkPersonalGitSecrets { inherit personalSopsFile; }
      ))
      // (lib.optionalAttrs (cfg.sshPrivate.role == "client") (
        sopsShared.mkSshPrivateSecrets { inherit personalSopsFile; }
      ))
      // (lib.optionalAttrs cfg.voiceInput {
        voice_input_openrouter_api_key = {
          sopsFile = commonSopsFile;
        };
      })
    );

    sops.templates =
      (lib.optionalAttrs cfg.atuin {
        "atuin-config" = {
          owner = username;
          content = sopsShared.mkAtuinConfigTemplate {
            syncAddressPlaceholder = if cfg.atuinSync then config.sops.placeholder.atuin_sync_address else null;
          };
        };
      })
      // {
        "git-identity" = {
          owner = username;
          content = sopsShared.mkGitIdentityTemplate {
            emailPlaceholder = config.sops.placeholder.git_email;
            namePlaceholder = config.sops.placeholder.git_name;
          };
        };
      }
      // (lib.optionalAttrs cfg.gitPersonal {
        "git-personal-identity" = {
          owner = username;
          content = sopsShared.mkGitIdentityTemplate {
            emailPlaceholder = config.sops.placeholder.git_personal_email;
            namePlaceholder = config.sops.placeholder.git_personal_name;
          };
        };
      })
      // (lib.optionalAttrs (cfg.sshPrivate.role == "client") {
        "ssh-private-config" = {
          owner = username;
          content = sopsShared.mkSshPrivateTemplate {
            lanPrefixPlaceholder = config.sops.placeholder.lan_prefix;
            vps01HostPlaceholder = config.sops.placeholder.vps01_host;
            inherit (cfg.sshPrivate) tier includeTailscale;
          };
        };
      });
  };
}
