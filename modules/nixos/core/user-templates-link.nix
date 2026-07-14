# Symlink user-owned sops templates into the workstation user's home.
# Runs after sops-nix renders templates to /run/secrets-rendered/<name>.
# The link set comes from modules/common/user-template-links.nix.
{
  config,
  lib,
  username,
  ...
}:
let
  cfg = config.mynix.profiles.userTemplates;

  inherit
    (import ../../common/user-template-links.nix {
      inherit config lib;
      homeDir = "/home/${username}";
    })
    links
    parents
    ;

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
