# Catalog of SSH public keys for tnmt's machines.
#
# All entries are *public* keys — safe to commit unencrypted. (See
# memory/security-hardening.md for why user keys are not stored in sops.)
#
# Structure:
#   hosts.<machine>  — per-machine key (one private key that lives only on
#                      that machine). ed25519 for newly-generated keys;
#                      RSA is retained only where downstream servers lack
#                      ed25519 support.
#
# How to use:
#   let pubkeys = import ../../modules/common/ssh-pubkeys.nix;
#   in users.users.tnmt.openssh.authorizedKeys.keys = with pubkeys; [
#     hosts.work_mac
#     hosts.dahlia
#   ];
{
  hosts = {
    # ed25519 per-host keys, generated with `ssh-keygen -t ed25519
    # -a 100` on each machine.
    dahlia = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPzvOWsFZvqwisafP0yU9X4xOl432dwl2t5tG/JqeKKE tnmt@dahlia";
    sunflower = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINIK98Iy+8/zRYoc4VRxc2dYCwkhz3i7RVz6DfaQuEN4 tnmt@sunflower";
    hydrangea = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICUZO2rriQloQ/mQADud1tIJRpvcyq8NngULwVTsIqm8 tnmt@hydrangea";
    obsync = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPZAfUnd8RmE5fcD42sbEySb/YVOo+f6sJ0DpYF1BGAS tnmt@obsync";
    vps01 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOEHy1KngSuTaq/DzzIWjmw24m7OPcVBHNSb1YiulTnm tnmt@vps01";
    silvea = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAoT5hp55zFSK6RTP3OqXW+sFlx0ppIhnb7mn4ikECWP tnmt@silvea";

    # 4096-bit RSA. Intentionally kept as RSA (not rotated to ed25519)
    # because some Linux servers this machine ssh's into require extra
    # libraries or configuration for ed25519 and the additional churn is
    # not worth it. Private key lives only on work_mac.
    work_mac = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC8DvXjmY4hBEaAxetwnbdRZYtyqMzsq5OXLDakNfwgNrezVJm6sp8pPtkPOCKpZ+Zur+94WMD1Xv3MYbEYaRsFd3IaqEJZLM7DTOVqv+lvTDotrm9HXEWY/7YwJc5nJTyhMvFX/jI6Y993DtJ4+VOH+PNDoP1DeR1DSmObXjFERnoCEMYHwBiSpqQSWxh1Vjb99WwaYi/oHg9PKfjtuW0FeKU4Ak0oNNhYS6M4vQxMNPccU2z43OfYdOF5uqO4TLF/TX46ATMNUpCbWvwmuM7PxxYu4yl9byOJub0/jJfqkttAEOCFuBcq6oqy6ZlrYJTNiUze/U2oqD4hh+2SVMBbqljVmN5fC2jxQrtxmA0dNTGh+RGv9/bly/AVsFsIm0bm/JNqsSFQsJ8AdQsh6uVmSBTryqTDib3RARPmaRDLgSwPruIwg5sY82j1/6/nlgP5rOZ/30UW1uQkvofKiZzVPQJ9gQzwd1zudMXT2KdV0eeSGvg5mVIRyXX6JV8Ko8Mz6MIQiqRkouQPjcWqc05xsGMLIInDH1ZGbrvCFa6OcoMNlrd8dQszPK9W9cy3OaruXIncfiYmvP4TfNkxo1RAXcPHN5839kKhTIrmpgSmovd1W5yYK2pnQU0HgBKJll9xc6Mh0p+GNK3K6j+9HSri3P01wu5LFHchs773KY+OEw== tnmt@work_mac";
  };
}
