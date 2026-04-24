{
  homeSopsFile,
  inputs,
  sopsShared,
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
      inherit
        homeSopsFile
        inputs
        sopsShared
        username
        ;
      theme = (import ../../../themes) "tokyonight-storm";
    };
  };
}
