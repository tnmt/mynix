{
  inputs,
  systemSopsFile,
  username,
  ...
}:
{
  imports = [
    inputs.sops-nix.darwinModules.sops
  ];

  sops = {
    defaultSopsFile = systemSopsFile;
    age.keyFile = "/Users/${username}/.config/sops/age/keys.txt";
  };
}
