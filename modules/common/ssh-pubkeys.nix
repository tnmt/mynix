# Catalog of SSH public keys for tnmt's machines.
#
# All entries are *public* keys — safe to commit unencrypted. (See
# memory/security-hardening.md for why user keys are not stored in sops.)
#
# Structure:
#   hosts.<machine>   — per-machine key (one private key that lives only on
#                       that machine). ed25519 for newly-generated keys;
#                       RSA is retained only where downstream servers lack
#                       ed25519 support.
#   mobile.<host><App> — per-app key on a mobile device. One key per app
#                        because mobile apps sandbox their key storage
#                        (cannot export/share between apps).
#
# How to use:
#   let pubkeys = import ../../modules/common/ssh-pubkeys.nix;
#   in users.users.tnmt.openssh.authorizedKeys.keys = with pubkeys; [
#     hosts.work_mac
#     hosts.dahlia
#     mobile.zfold7SshTerm
#   ];
{
  hosts = {
    # ed25519 per-host keys, generated with `ssh-keygen -t ed25519
    # -a 100` on each machine.
    dahlia = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPzvOWsFZvqwisafP0yU9X4xOl432dwl2t5tG/JqeKKE tnmt@dahlia";
    sunflower = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINIK98Iy+8/zRYoc4VRxc2dYCwkhz3i7RVz6DfaQuEN4 tnmt@sunflower";
    hydrangea = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICUZO2rriQloQ/mQADud1tIJRpvcyq8NngULwVTsIqm8 tnmt@hydrangea";
    work_mac = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMEbttselTEO+niVdO0fLRoC8qFRslEVtPpFgsGa7xUQ tnmt@work_mac";
  };

  # Mobile app keys. All entries assumed to share the SSH Term-family
  # MAC-algorithm limitation (see modules/services/openssh.nix). If a
  # future mobile app supports ETM MACs natively, move it out of this
  # attrset so the workaround does not apply.
  mobile = {
    zfold7SshTerm = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBiX6l6ZOU+EtRG668IEGd4WcVl6cNslyxu8yZIXS68q tnmt@zfold7-ssh-term";
    iphone13miniSshTerm = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPpdh8qwkp4MQ236cZQEdeJHzPBZxDR2mauNRYVVZrn3 tnmt@iphone13mini-ssh-term";
  };
}
