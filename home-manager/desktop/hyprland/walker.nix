{
  pkgs,
  theme,
  ...
}:
let
  fonts = import ../fonts.nix;
in
{
  home.packages = [
    pkgs.walker
    pkgs.elephant
  ];

  xdg.configFile."walker/config.toml".text = ''
    force_keyboard_focus = true
    selection_wrap = true
    hide_action_hints = true
    terminal = "ghostty"
    theme = "current"

    [placeholders]
    "default" = { input = " Search...", list = "No Results" }

    [keybinds]
    quick_activate = []

    [columns]
    symbols = 1

    [providers]
    max_results = 256
    default = [
      "desktopapplications",
      "websearch",
    ]

    [[providers.prefixes]]
    prefix = "/"
    provider = "providerlist"

    [[providers.prefixes]]
    prefix = "."
    provider = "files"

    [[providers.prefixes]]
    prefix = ":"
    provider = "symbols"

    [[providers.prefixes]]
    prefix = "="
    provider = "calc"

    [[providers.prefixes]]
    prefix = "@"
    provider = "websearch"

    [[providers.prefixes]]
    prefix = "$"
    provider = "clipboard"
  '';

  xdg.configFile."elephant/clipboard.toml".text = ''
    max_items = 10000
  '';

  xdg.configFile."walker/themes/current/style.css".text = ''
    @define-color selected-text ${theme.accent};
    @define-color text ${theme.foreground};
    @define-color base ${theme.background};
    @define-color border ${theme.foreground};
    @define-color foreground ${theme.foreground};
    @define-color background ${theme.background};

    * {
      all: unset;
    }

    * {
      font-family: '${fonts.sans}', '${fonts.monospace}';
      font-size: 18px;
      color: @text;
    }

    scrollbar {
      opacity: 0;
    }

    .normal-icons {
      -gtk-icon-size: 16px;
    }

    .large-icons {
      -gtk-icon-size: 32px;
    }

    .box-wrapper {
      background: alpha(@base, 0.95);
      padding: 20px;
      border: 2px solid @border;
    }

    .search-container {
      background: @base;
      padding: 10px;
    }

    .input placeholder {
      opacity: 0.5;
    }

    .input:focus,
    .input:active {
      box-shadow: none;
      outline: none;
    }

    child:selected .item-box * {
      color: @selected-text;
    }

    .item-box {
      padding-left: 14px;
    }

    .item-text-box {
      all: unset;
      padding: 14px 0;
    }

    .item-subtext {
      font-size: 0px;
      min-height: 0px;
      margin: 0px;
      padding: 0px;
    }

    .item-image {
      margin-right: 14px;
      -gtk-icon-transform: scale(0.9);
    }

    .current {
      font-style: italic;
    }

    .keybind-hints {
      background: @background;
      padding: 10px;
      margin-top: 10px;
    }
  '';
  xdg.configFile."walker/themes/current/layout.xml" = {
    source = ./walker/themes/current/layout.xml;
  };
}
