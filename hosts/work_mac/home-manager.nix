{ pkgs, inputs, ... }:
{
  imports = [
    ../../home-manager/base
    ../../home-manager/darwin
    ../../home-manager/desktop/terminal/alacritty
    ../../home-manager/work
  ];

  # work_mac specific packages
  home.packages = with pkgs; [
    # oneaws (work_mac only)
    inputs.oneaws.packages.${pkgs.system}.default
  ];
}
