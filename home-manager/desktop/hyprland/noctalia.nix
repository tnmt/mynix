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

      osd.kinds.keyboard_layout = false;

      widget.clock = {
        format = "{:%Y-%m-%d %H:%M:%S}";
        timezone = "Asia/Tokyo";
      };

      wallpaper = {
        enabled = true;
        default.path = ./wallpaper/abstract-black-background.jpg;
      };
    };
  };
}
