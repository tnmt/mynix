{ theme, pkgs, ... }:
let
  themeSrc = pkgs.fetchFromGitHub theme.src;
in
{
  programs.btop = {
    enable = true;
    settings = {
      color_theme = theme.btop;
      theme_background = true;
      truecolor = true;
      rounded_corners = true;
      graph_symbol = "braille";
      update_ms = 2000;
      proc_sorting = "cpu lazy";
      proc_colors = true;
      proc_gradient = true;
      proc_mem_bytes = true;
      proc_cpu_graphs = true;
      show_uptime = true;
      show_cpu_freq = true;
      check_temp = true;
      show_coretemp = true;
      show_battery = true;
      vim_keys = false;
      clock_format = "%X";
    };
  };

  # Use the official folke/tokyonight.nvim extras/btop theme (matches other apps)
  xdg.configFile."btop/themes/${theme.btop}.theme".source = "${themeSrc}/${theme.extras.btop}";
}
