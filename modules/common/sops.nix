# Shared sops baseline: decrypt with the host SSH key by default, so the
# system layer never depends on a per-user age key under /home or /Users.
# On NixOS, /home is unmounted when sops-install-secrets runs, so a
# user-owned age key there would deadlock boot on hosts where /home lives
# on a separately decrypted device. Hosts that need a different scheme can
# override. The OS entry points at modules/{nixos,darwin}/core/sops.nix
# import this next to their sops-nix module.
{
  lib,
  systemSopsFile,
  ...
}:
{
  sops = {
    defaultSopsFile = lib.mkDefault systemSopsFile;
    age.keyFile = lib.mkDefault null;
    age.sshKeyPaths = lib.mkDefault [ "/etc/ssh/ssh_host_ed25519_key" ];
  };
}
