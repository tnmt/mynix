{ pkgs, ... }:
let
  vncDahlia = pkgs.writeShellApplication {
    name = "vnc-dahlia";
    text = builtins.readFile ./scripts/vnc-dahlia;
  };
in
{
  home.packages = [ vncDahlia ];
}
