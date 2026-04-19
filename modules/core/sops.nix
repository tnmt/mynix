{
  config,
  inputs,
  lib,
  systemSopsFile,
  username,
  ...
}:
{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    defaultSopsFile = lib.mkDefault systemSopsFile;
    age.keyFile = lib.mkDefault "${config.users.users.${username}.home}/.config/sops/age/keys.txt";
  };
}
