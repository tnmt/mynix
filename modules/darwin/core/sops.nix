{
  inputs,
  lib,
  systemSopsFile,
  ...
}:
{
  imports = [
    inputs.sops-nix.darwinModules.sops
  ];

  # Mirror the NixOS default: decrypt with the host SSH key so the
  # system layer doesn't depend on a per-user age key under /Users.
  sops = {
    defaultSopsFile = lib.mkDefault systemSopsFile;
    age.keyFile = lib.mkDefault null;
    age.sshKeyPaths = lib.mkDefault [ "/etc/ssh/ssh_host_ed25519_key" ];
  };
}
