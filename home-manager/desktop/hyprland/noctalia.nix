{
  config,
  inputs,
  pkgs,
  ...
}:
let
  fonts = import ../fonts.nix;
in
{
  imports = [ inputs.noctalia.homeModules.default ];

  programs.noctalia = {
    enable = true;
    package = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
    systemd.enable = true;

    settings = {
      theme = {
        mode = "dark";
        # "custom" (via customPalettes + pkgs.fetchFromGitHub of noctalia-dev/community-palettes)
        # kept getting silently overridden back to a "community"-sourced resolution by
        # Noctalia's own state.toml layer. Since noctalia-dev/community-palettes already
        # publishes "Tokyo Night Storm" under the same name, use the community source
        # directly instead of fighting that layer.
        source = "community";
        community_palette = "Tokyo Night Storm";
      };

      shell = {
        font_family = fonts.sans;
        lang = "en";
        show_location = false;

        # Mac-style screenshot flow: no per-shortcut save-vs-clipboard split,
        # every capture both saves to file and copies to clipboard.
        screenshot = {
          save_to_file = true;
          copy_to_clipboard = true;
          directory = "${config.home.homeDirectory}/Pictures/Screenshots";
        };
      };

      location.auto_locate = true;

      plugins = {
        enabled = [
          "kenn/keybind-cheatsheet"
          "mindnbytes/nix-status"
          "nightwatch75/file-search"
          "noctalia/screen_recorder"
        ];
        auto_update = "none";
        source = [
          {
            name = "official-pinned";
            kind = "path";
            location = "${inputs.noctalia-official-plugins}";
            enabled = true;
          }
          {
            name = "community-pinned";
            kind = "path";
            location = "${inputs.noctalia-community-plugins}";
            enabled = true;
          }
        ];
      };

      plugin_settings = {
        # The official recorder widget also adopts recordings started by the
        # existing screen-record helper. Keep it hidden until a recording is
        # active; while active it becomes a red, clickable stop button.
        "noctalia/screen_recorder".hide_inactive = true;

        "kenn/keybind-cheatsheet" = {
          compositor = "hyprland";
          hyprland_parser = "lua";
          columns = 3;
          show_undescribed = false;
          show_actions = false;
        };

        "mindnbytes/nix-status" = {
          flake_dir = "${config.home.homeDirectory}/ghq/github.com/tnmt/mynix";
          nixos_configuration = "dahlia";
        };

        "nightwatch75/file-search" = {
          search_folder = config.home.homeDirectory;
          exclude_dirs = ".git, node_modules, .cache, .venv, Steam";
          show_hidden = false;
          max_results = 50;
        };
      };

      bar.default.end = [
        "media"
        "tray"
        "nix-status"
        "screen-recorder"
        "notifications"
        "clipboard"
        "network"
        "bluetooth"
        "volume"
        "brightness"
        "battery"
        "control-center"
        "session"
      ];

      # Noctalia's native idle service respects Wayland idle inhibitors and the
      # caffeine toggle. Lock first, then turn the displays off one minute later;
      # activity restores display power automatically.
      idle = {
        pre_action_fade_seconds = 2.0;
        behavior = {
          lock = {
            timeout = 600;
            action = "lock";
            enabled = true;
          };
          "screen-off" = {
            timeout = 660;
            action = "screen_off";
            enabled = true;
          };
        };
      };

      osd.kinds.keyboard_layout = false;

      widget = {
        clock = {
          format = "{:%Y-%m-%d %H:%M:%S}";
          timezone = "Asia/Tokyo";
        };

        screen-recorder = {
          type = "noctalia/screen_recorder:recorder";
          actions.middle = "none";
        };

        nix-status.type = "mindnbytes/nix-status:status";
      };

      wallpaper = {
        enabled = true;
        default.path = ./wallpaper/abstract-black-background.jpg;
      };
    };
  };
}
