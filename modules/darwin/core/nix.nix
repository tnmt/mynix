{ pkgs, ... }:
{
  imports = [ ../../common/nix-settings.nix ];

  environment.systemPackages = with pkgs; [
    home-manager
    nh
  ];
}
