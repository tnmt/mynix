{ pkgs, ... }:
{
  imports = [
    ./gh-triage
  ];

  home.packages = with pkgs; [
    kagiana
    openstackclient
  ];
}
