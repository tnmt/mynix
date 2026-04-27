# Symlink user-owned sops templates into the workstation user's home.
# Runs after sops-nix renders templates to /run/secrets-rendered/<name>.
# The companion options/secrets/templates definitions live in
# profiles/common/user-sops.nix.
{
  config,
  lib,
  username,
  ...
}:
let
  cfg = config.profiles.userTemplates;
  homeDir = "/home/${username}";

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
    ]);

  parents = lib.unique (map (l: builtins.dirOf l.link) links);
  mkdirCmds = lib.concatMapStringsSep "\n" (d: "mkdir -p ${d}") parents;
  lnCmds = lib.concatMapStringsSep "\n" (l: "ln -sf ${l.target} ${l.link}") links;
in
{
  config = lib.mkIf cfg.enable {
    systemd.services.sops-link-user-configs = {
      description = "Symlink sops templates into the workstation user's home";
      after = [ "sops-nix.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        User = username;
        RemainAfterExit = true;
      };
      script = ''
        ${mkdirCmds}
        ${lnCmds}
      '';
    };
  };
}
