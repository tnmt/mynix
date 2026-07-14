{ theme, ... }:
{
  programs.zathura = {
    enable = true;
    options = {
      default-bg = theme.background;
      default-fg = theme.foreground;
      statusbar-fg = theme.foreground;
      statusbar-bg = theme.bg_dark;
      inputbar-bg = theme.bg_dark;
      inputbar-fg = theme.foreground;
      notification-bg = theme.background;
      notification-fg = theme.foreground;
      notification-error-bg = theme.color1;
      notification-error-fg = theme.background;
      notification-warning-bg = theme.color3;
      notification-warning-fg = theme.background;
      highlight-color = theme.accent;
      highlight-active-color = theme.teal;
      completion-bg = theme.bg_dark;
      completion-fg = theme.foreground;
      completion-highlight-bg = theme.bg_highlight;
      completion-highlight-fg = theme.foreground;
      recolor-lightcolor = theme.background;
      recolor-darkcolor = theme.foreground;
      selection-clipboard = "clipboard";
    };
  };
}
