{
  commonOverlays,
  homeSopsFile,
  inputs,
  pkgs,
  username,
  ...
}:
let
  homeDirectory = "/Users/${username}";
  pkgs-stable = import inputs.nixpkgs-stable {
    inherit (pkgs.stdenv.hostPlatform) system;
    overlays = commonOverlays;
    config.allowUnfree = true;
  };
in
{
  imports = [
    inputs.home-manager-darwin.darwinModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = false;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit homeSopsFile inputs username;
      theme = (import ../../../themes) "tokyonight-storm";
      inherit pkgs-stable;
    };
    users."${username}" = {
      _module.args.pkgsPath = inputs.nixpkgs-darwin;
      nixpkgs = {
        config.allowUnfree = true;
        overlays = commonOverlays;
      };
      imports = [
        inputs.sops-nix.homeManagerModules.sops
        (import ../../../home-manager/defaults.nix {
          inherit homeDirectory homeSopsFile username;
        })
      ];
    };
  };
}
