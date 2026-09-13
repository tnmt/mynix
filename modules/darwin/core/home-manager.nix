{
  commonOverlays,
  homeDirectory,
  inputs,
  theme,
  username,
  ...
}:
{
  imports = [
    inputs.home-manager-darwin.darwinModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = false;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit
        homeDirectory
        inputs
        theme
        username
        ;
    };
    users."${username}" = {
      _module.args.pkgsPath = inputs.nixpkgs-darwin;
      nixpkgs = {
        config.allowUnfree = true;
        overlays = commonOverlays;
      };
      imports = [
        (import ../../../home-manager/defaults.nix {
          inherit
            homeDirectory
            username
            ;
        })
      ];
    };
  };
}
