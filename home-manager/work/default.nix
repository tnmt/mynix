{ lib, pkgs, ... }:
{
  imports = [
    ./gh-triage
  ];

  home.packages =
    with pkgs;
    [
      consul-template
      kagiana
      openstackclient
      vault
    ]
    ++ lib.optionals stdenv.isLinux [
      _1password-cli
    ];
}
