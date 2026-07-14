# macOS counterpart to modules/nixos/core/user-templates-link.nix.
# nix-darwin has no user systemd, so symlinks are placed via the
# system activation phase. Activation runs as root; mkdir results are
# chown'd back to the user so they can write inside the new dirs.
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
      homeDir = "/Users/${username}";
    })
    links
    parents
    ;

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
