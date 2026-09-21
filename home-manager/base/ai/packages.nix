{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ax
    ccusage
    claude-code
    codex
    rtk
  ];
}
