{ theme, ... }:
{
  programs.yazi = {
    enable = true;
    shellWrapperName = "yy";
    settings = {
      mgr = {
        show_hidden = true;
      };
    };
    theme = {
      mgr = {
        cwd = {
          fg = theme.accent;
        };
        find_keyword = {
          fg = theme.color1;
          bold = true;
          italic = true;
          underline = true;
        };
        find_position = {
          fg = theme.color5;
          bg = "reset";
          bold = true;
          italic = true;
        };
        marker_copied = {
          fg = theme.color2;
          bg = theme.color2;
        };
        marker_cut = {
          fg = theme.color3;
          bg = theme.color1;
        };
        marker_marked = {
          fg = theme.accent;
          bg = theme.color6;
        };
        marker_selected = {
          fg = theme.color3;
          bg = theme.color3;
        };
        count_copied = {
          fg = theme.color0;
          bg = theme.color2;
        };
        count_cut = {
          fg = theme.color0;
          bg = theme.color3;
        };
        count_selected = {
          fg = theme.color0;
          bg = theme.accent;
        };
        border_symbol = "│";
        border_style = {
          fg = theme.color8;
        };
      };
      tabs = {
        active = {
          fg = theme.bg_highlight;
          bg = theme.accent;
          bold = true;
        };
        inactive = {
          fg = theme.accent;
          bg = theme.bg_highlight;
        };
      };
      mode = {
        normal_main = {
          fg = theme.bg_highlight;
          bg = theme.accent;
          bold = true;
        };
        normal_alt = {
          fg = theme.accent;
          bg = theme.bg_highlight;
        };
        select_main = {
          fg = theme.bg_highlight;
          bg = theme.color2;
          bold = true;
        };
        select_alt = {
          fg = theme.accent;
          bg = theme.bg_highlight;
        };
        unset_main = {
          fg = theme.bg_highlight;
          bg = theme.color5;
          bold = true;
        };
        unset_alt = {
          fg = theme.accent;
          bg = theme.bg_highlight;
        };
      };
      status = {
        overall = {
          fg = theme.accent;
        };
        sep_left = {
          open = "";
          close = "";
        };
        sep_right = {
          open = "";
          close = "";
        };
        progress_label = {
          fg = theme.bg_highlight;
          bold = true;
        };
        progress_normal = {
          fg = theme.accent;
          bg = theme.bg_highlight;
        };
        progress_error = {
          fg = theme.color1;
          bg = theme.bg_highlight;
        };
        perm_sep = {
          fg = theme.accent;
        };
        perm_type = {
          fg = theme.color2;
        };
        perm_read = {
          fg = theme.color3;
        };
        perm_write = {
          fg = theme.color1;
        };
        perm_exec = {
          fg = theme.color5;
        };
      };
      pick = {
        border = {
          fg = theme.accent;
        };
        active = {
          fg = theme.color5;
          bold = true;
        };
        inactive = { };
      };
      input = {
        border = {
          fg = theme.accent;
        };
        title = { };
        value = { };
        selected = {
          reversed = true;
        };
      };
      cmp = {
        border = {
          fg = theme.accent;
        };
      };
      tasks = {
        border = {
          fg = theme.accent;
        };
        title = { };
        hovered = {
          fg = theme.color5;
          underline = true;
        };
      };
      which = {
        mask = {
          bg = theme.color8;
        };
        cand = {
          fg = theme.color2;
        };
        rest = {
          fg = theme.color7;
        };
        desc = {
          fg = theme.color5;
        };
        separator = "  ";
        separator_style = {
          fg = theme.comment;
        };
      };
      help = {
        on = {
          fg = theme.color2;
        };
        run = {
          fg = theme.color5;
        };
        hovered = {
          reversed = true;
          bold = true;
        };
        footer = {
          fg = theme.color0;
          bg = theme.color7;
        };
      };
      spot = {
        border = {
          fg = theme.accent;
        };
        title = {
          fg = theme.accent;
        };
        tbl_col = {
          fg = theme.color2;
        };
        tbl_cell = {
          fg = theme.color5;
          bg = theme.bg_highlight;
        };
      };
      notify = {
        title_info = {
          fg = theme.color2;
        };
        title_warn = {
          fg = theme.color1;
        };
        title_error = {
          fg = theme.color3;
        };
      };
      filetype = {
        rules = [
          {
            mime = "image/*";
            fg = theme.color3;
          }
          {
            mime = "video/*";
            fg = theme.color1;
          }
          {
            mime = "audio/*";
            fg = theme.color1;
          }
          {
            mime = "application/zip";
            fg = theme.color5;
          }
          {
            mime = "application/x-tar";
            fg = theme.color5;
          }
          {
            mime = "application/x-bzip*";
            fg = theme.color5;
          }
          {
            mime = "application/x-bzip2";
            fg = theme.color5;
          }
          {
            mime = "application/x-7z-compressed";
            fg = theme.color5;
          }
          {
            mime = "application/x-rar";
            fg = theme.color5;
          }
          {
            mime = "application/x-xz";
            fg = theme.color5;
          }
          {
            mime = "application/doc";
            fg = theme.color2;
          }
          {
            mime = "application/epub+zip";
            fg = theme.color2;
          }
          {
            mime = "application/pdf";
            fg = theme.color2;
          }
          {
            mime = "application/rtf";
            fg = theme.color2;
          }
          {
            mime = "application/vnd.*";
            fg = theme.color2;
          }
          {
            url = "*";
            fg = theme.foreground;
          }
          {
            url = "*/";
            fg = theme.accent;
          }
        ];
      };
    };
  };
}
