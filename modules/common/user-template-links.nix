# Computes the sops-template symlink set (target/link pairs and the
# parent dirs to create) shared by
# modules/{nixos,darwin}/core/user-templates-link.nix, which turn it
# into a systemd oneshot / activation script. The companion
# options/secrets/templates definitions live in
# profiles/common/user-sops.nix.
{
  config,
  lib,
  homeDir,
}:
let
  cfg = config.mynix.profiles.userTemplates;

  links =
    (lib.optionals cfg.atuin [
      {
        target = config.sops.templates."atuin-config".path;
        link = "${homeDir}/.config/atuin/config.toml";
      }
    ])
    ++ [
      {
        target = config.sops.templates."git-identity".path;
        link = "${homeDir}/.config/git/identity";
      }
    ]
    ++ (lib.optionals cfg.gitPersonal [
      {
        target = config.sops.templates."git-personal-identity".path;
        link = "${homeDir}/.config/git/personal-identity";
      }
    ])
    ++ (lib.optionals (cfg.sshPrivate.role == "client") [
      {
        target = config.sops.templates."ssh-private-config".path;
        link = "${homeDir}/.ssh/conf.d/private.config";
      }
    ])
    ++ (lib.optionals cfg.tnmtInfo [
      {
        target = config.sops.secrets.tnmt_info_mask_dict.path;
        link = "${homeDir}/.config/tnmt-info/journal-import/mask-dict.yaml";
      }
      {
        target = config.sops.secrets.tnmt_info_ai_policy.path;
        link = "${homeDir}/.config/tnmt-info/journal-import/ai-policy.md";
      }
    ]);
in
{
  inherit links;
  parents = lib.unique (map (l: builtins.dirOf l.link) links);
}
