{ pkgs, theme, ... }:
let
  themeSrc = theme.srcDrv pkgs;
in
{
  # Vencord は nixpkgs 管理（自動DLの dist が腐るのを防ぐ）
  home.packages = [ (pkgs.vesktop.override { withSystemVencord = true; }) ];

  # Tokyo Night Storm theme
  xdg.configFile."vesktop/themes/tokyonight-storm.css".source = "${themeSrc}/${theme.extras.discord}";
}
