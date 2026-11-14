{ pkgs, ... }:
let
  vncDahlia = pkgs.writeShellApplication {
    name = "vnc-dahlia";
    text = builtins.readFile ./scripts/vnc-dahlia;
  };
in
{
  imports = [ ../desktop/sheprd.nix ];

  home.packages = [ vncDahlia ];
}
