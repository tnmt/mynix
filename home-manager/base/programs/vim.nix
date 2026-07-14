{
  pkgs,
  theme,
  ...
}:
let
  themeSrc = theme.srcDrv pkgs;
in
{
  home = {
    packages = [ pkgs.vim ];

    file.".vim/colors/${theme.vim}.vim".source = "${themeSrc}/${theme.extras.vim}";
    file.".vimrc".text = ''
      set termguicolors
      colorscheme ${theme.vim}
    '';
  };
}
