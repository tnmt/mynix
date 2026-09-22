{
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
      };

      wallpaper = {
        enabled = true;
        default.path = ./wallpaper/abstract-black-background.jpg;
      };
    };
  };
}
