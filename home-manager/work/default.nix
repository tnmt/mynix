{ lib, pkgs, ... }:
{
  imports = [
    ./gh-triage
  ];

  home.packages =
    with pkgs;
    [
      kagiana
      openstackclient
    ]
    ++ lib.optionals stdenv.isLinux [
      _1password-cli
    ];
}
