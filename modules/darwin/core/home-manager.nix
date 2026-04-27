{
  commonOverlays,
  inputs,
  username,
  ...
}:
let
  homeDirectory = "/Users/${username}";
in
{
  imports = [
    inputs.home-manager-darwin.darwinModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = false;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit
        inputs
        username
        ;
      theme = (import ../../../themes) "tokyonight-storm";
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
