{
  pkgs,
  theme,
  ...
}:
let
  themeSrc = pkgs.fetchFromGitHub theme.src;
in
{
  home = {
    packages = [ pkgs.vim ];

    file.".vim/colors/tokyonight-storm.vim".source = "${themeSrc}/${theme.extras.vim}";
    file.".vimrc".text = ''
      set termguicolors
      colorscheme tokyonight-storm
    '';
  };
}
