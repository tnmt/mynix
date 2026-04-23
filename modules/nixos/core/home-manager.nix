{
  homeSopsFile,
  inputs,
  username,
  ...
}:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit homeSopsFile inputs username;
      theme = (import ../../../themes) "tokyonight-storm";
    };
  };
}
