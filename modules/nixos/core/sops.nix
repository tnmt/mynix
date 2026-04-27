{
  inputs,
  lib,
  systemSopsFile,
  ...
}:
{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  # Decrypt sops with the host SSH key by default. /home is unmounted
  # when sops-install-secrets runs, so a user-owned age key under /home
  # would deadlock boot on hosts where /home lives on a separately
  # decrypted device. Hosts that need a different scheme can override.
  sops = {
    defaultSopsFile = lib.mkDefault systemSopsFile;
    age.keyFile = lib.mkDefault null;
    age.sshKeyPaths = lib.mkDefault [ "/etc/ssh/ssh_host_ed25519_key" ];
  };
}
