{ pkgs, theme, ... }:
let
  themeSrc = theme.srcDrv pkgs;
  rawTheme = builtins.fromTOML (builtins.readFile "${themeSrc}/${theme.extras.yazi}");

  # tokyonight.nvim's yazi extras still emit legacy `name`-matched filetype
  # rules (e.g. orphan/exec/fallback). Current yazi requires every rule to
  # carry `url` or `mime`, so rename `name` -> `url` to keep them working.
  fixFiletypeRule =
    rule:
    if rule ? name && !(rule ? url) then
      (builtins.removeAttrs rule [ "name" ]) // { url = rule.name; }
    else
      rule;
in
{
  programs.yazi = {
    enable = true;
    shellWrapperName = "yy";
    settings = {
      mgr = {
        show_hidden = true;
      };
    };
    theme = rawTheme // {
      filetype = rawTheme.filetype // {
        rules = map fixFiletypeRule rawTheme.filetype.rules;
      };
    };
  };
}
