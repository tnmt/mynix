{ pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    openstackclient

    # oneaws
    inputs.oneaws.packages.${pkgs.system}.default
  ];
}
