# Tokyo Night Storm color palette
# Ported from chezmoi dot_config/theme/colors/tokyo-night-storm.toml
{
  name = "tokyonight-storm";

  # Theme source repository (extras/ contains configs for many programs)
  src = {
    owner = "folke";
    repo = "tokyonight.nvim";
    rev = "v4.14.1";
    hash = "sha256-kQsV0x8/ycFp3+S6YKyiKFsAG5taOdQmx/dMuDqGyEQ=";
  };

  # Extras file paths (relative to src)
  extras = {
    alacritty = "extras/alacritty/tokyonight_storm.toml";
    delta = "extras/delta/tokyonight_storm.gitconfig";
    foot = "extras/foot/tokyonight_storm.ini";
    fzf = "extras/fzf/tokyonight_storm.sh";
    eza = "extras/eza/tokyonight_storm.yml";
    yazi = "extras/yazi/tokyonight_storm.toml";
    ghostty = "extras/ghostty/tokyonight_storm";
    gitui = "extras/gitui/tokyonight_storm.ron";
    kitty = "extras/kitty/tokyonight_storm.conf";
    tmux = "extras/tmux/tokyonight_storm.tmux";
    discord = "extras/discord/tokyonight_storm.css";
    slack = "extras/slack/tokyonight_storm.txt";
    vim = "extras/vim/colors/tokyonight-storm.vim";
    btop = "extras/btop/tokyonight_storm.theme";
  };

  # Btop (theme name matches extras/btop/*.theme basename)
  btop = "tokyonight_storm";

  # Vim (neovim hardcodes its colorscheme in lua — see neovim/config/lua/plugins/ui.lua)
  vim = "tokyonight-storm";

  # Ghostty (theme name = basename of extras.ghostty placed under ghostty/themes/)
  ghostty = "tokyonight_storm";

  # Kitty (conf name = basename of extras.kitty placed under kitty/)
  kitty = "tokyonight_storm";

  # GTK
  gtk = "Tokyonight-Dark-Storm";
  gtkIcon = "Tokyonight-Dark";

  # Bat
  bat = {
    name = "tokyonight_storm";
    file = "extras/sublime/tokyonight_storm.tmTheme";
  };

  # Delta
  delta = "tokyonight_storm";

  # Base colors
  background = "#24283b";
  foreground = "#c0caf5";
  accent = "#7aa2f7";

  # ANSI colors
  color0 = "#1d202f";
  color1 = "#f7768e";
  color2 = "#9ece6a";
  color3 = "#e0af68";
  color4 = "#7aa2f7";
  color5 = "#bb9af7";
  color6 = "#7dcfff";
  color7 = "#a9b1d6";
  color8 = "#414868";
  color9 = "#ff899d";
  color10 = "#9fe044";
  color11 = "#faba4a";
  color12 = "#8db0ff";
  color13 = "#c7a9ff";
  color14 = "#a4daff";
  color15 = "#c0caf5";

  # Extended palette
  bg_dark = "#1f2335";
  bg_highlight = "#292e42";
  comment = "#565f89";
  dark5 = "#737aa2";
  orange = "#ff9e64";
  teal = "#73daca";
  magenta = "#ff007c";
}
