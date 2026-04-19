{
  inputs,
  lib,
  systemSopsFile,
  username,
  ...
}:
{
  imports = [
    inputs.sops-nix.darwinModules.sops
  ];

  sops = {
    defaultSopsFile = lib.mkDefault systemSopsFile;
    age.keyFile = lib.mkDefault "/Users/${username}/.config/sops/age/keys.txt";
  };
}
