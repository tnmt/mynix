{
  homeDirectory,
  inputs,
  theme,
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
        homeDirectory
        inputs
        theme
        username
        ;
    };
  };
}
