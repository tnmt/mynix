# Catalog of SSH public keys for tnmt's machines.
#
# All entries are *public* keys — safe to commit unencrypted. (See
# memory/security-hardening.md for why user keys are not stored in sops.)
#
# Structure:
#   hosts.<machine>          — per-machine generated key (one private key
#                              that lives only on that machine)
#   legacy.<id>              — pre-migration shared / unidentified keys.
#                              Each entry should have a TODO describing
#                              what needs to happen before it can be
#                              removed.
#
# How to use:
#   let pubkeys = import ../../modules/common/ssh-pubkeys.nix;
#   in users.users.tnmt.openssh.authorizedKeys.keys = with pubkeys; [
#     legacy.workmac_rsa
#     legacy.goldmoon_ed25519
#   ];
{
  hosts = {
    # Per-machine ed25519 keys, generated with `ssh-keygen -t ed25519
    # -a 100` on each machine. The matching private key lives only on
    # the named host. Add a new entry as each machine migrates off the
    # legacy shared keys below.
    dahlia = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPzvOWsFZvqwisafP0yU9X4xOl432dwl2t5tG/JqeKKE tnmt@dahlia";
    sunflower = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINIK98Iy+8/zRYoc4VRxc2dYCwkhz3i7RVz6DfaQuEN4 tnmt@sunflower";
    hydrangea = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICUZO2rriQloQ/mQADud1tIJRpvcyq8NngULwVTsIqm8 tnmt@hydrangea";
  };

  legacy = {
    # 4096-bit RSA generated long ago on the company Mac. The private
    # key only exists on work_mac. Currently authorized on personal
    # machines so the user can ssh from work_mac into them.
    # TODO: replace with hosts.work_mac (new ed25519) once work_mac
    # has migrated, then drop this entry.
    workmac_rsa = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC8DvXjmY4hBEaAxetwnbdRZYtyqMzsq5OXLDakNfwgNrezVJm6sp8pPtkPOCKpZ+Zur+94WMD1Xv3MYbEYaRsFd3IaqEJZLM7DTOVqv+lvTDotrm9HXEWY/7YwJc5nJTyhMvFX/jI6Y993DtJ4+VOH+PNDoP1DeR1DSmObXjFERnoCEMYHwBiSpqQSWxh1Vjb99WwaYi/oHg9PKfjtuW0FeKU4Ak0oNNhYS6M4vQxMNPccU2z43OfYdOF5uqO4TLF/TX46ATMNUpCbWvwmuM7PxxYu4yl9byOJub0/jJfqkttAEOCFuBcq6oqy6ZlrYJTNiUze/U2oqD4hh+2SVMBbqljVmN5fC2jxQrtxmA0dNTGh+RGv9/bly/AVsFsIm0bm/JNqsSFQsJ8AdQsh6uVmSBTryqTDib3RARPmaRDLgSwPruIwg5sY82j1/6/nlgP5rOZ/30UW1uQkvofKiZzVPQJ9gQzwd1zudMXT2KdV0eeSGvg5mVIRyXX6JV8Ko8Mz6MIQiqRkouQPjcWqc05xsGMLIInDH1ZGbrvCFa6OcoMNlrd8dQszPK9W9cy3OaruXIncfiYmvP4TfNkxo1RAXcPHN5839kKhTIrmpgSmovd1W5yYK2pnQU0HgBKJll9xc6Mh0p+GNK3K6j+9HSri3P01wu5LFHchs773KY+OEw== tnmt@work_mac (legacy RSA)";

    # ed25519 originally generated on the now-decommissioned "goldmoon"
    # machine. The same private key has been carried across personal
    # machines (currently lives on dahlia, hydrangea, and sunflower)
    # and acts as the de-facto shared personal key. Authorized on
    # dahlia and sunflower today.
    # TODO: generate a per-host ed25519 on each of the 3 machines that
    # currently holds this key, register them under hosts.<machine>,
    # add them to every receiver's authorized_keys, then revoke.
    goldmoon_ed25519 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEIvp9PeEFVc7pupvKgW3oe4uugSAj5M3pwh9sVNGB3k tnmt@goldmoon.local (legacy shared personal key)";
  };
}
