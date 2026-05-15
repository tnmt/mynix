# macOS counterpart to modules/nixos/core/user-templates-link.nix.
# nix-darwin has no user systemd, so symlinks are placed via the
# system activation phase. Activation runs as root; mkdir results are
# chown'd back to the user so they can write inside the new dirs.
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
  homeDir = "/Users/${username}";

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
  mkdirCmds = lib.concatMapStringsSep "\n" (d: ''
    mkdir -p ${d}
    chown ${username} ${d}
  '') parents;
  lnCmds = lib.concatMapStringsSep "\n" (l: "ln -sfn ${l.target} ${l.link}") links;
in
{
  config = lib.mkIf cfg.enable {
    system.activationScripts.postActivation.text = lib.mkAfter ''
      ${mkdirCmds}
      ${lnCmds}
    '';
  };
}
