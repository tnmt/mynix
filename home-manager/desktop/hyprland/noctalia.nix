{
  inputs,
  pkgs,
  ...
}:
let
  fonts = import ../fonts.nix;

  # "Tokyo Night Storm" palette from noctalia's community palette repo — reused as-is
  # instead of hand-mapping themes/tokyonight-storm.nix colors to Noctalia's role keys.
  communityPalettes = pkgs.fetchFromGitHub {
    owner = "noctalia-dev";
    repo = "community-palettes";
    rev = "c81aa633315b5bbdace0c2604925077d58af24c4";
    hash = "sha256-cqdZuBe0ph8cmVwBQEJbXRZb581VElN0PVs7UKNUV5Y=";
  };
in
{
  imports = [ inputs.noctalia.homeModules.default ];

  programs.noctalia = {
    enable = true;
    package = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
    systemd.enable = true;

    customPalettes."Tokyo Night Storm" =
      "${communityPalettes}/Tokyo Night Storm/Tokyo Night Storm.json";

    settings = {
      theme = {
        mode = "dark";
        source = "custom";
        custom_palette = "Tokyo Night Storm";
      };

      shell = {
        font = fonts.sans;
      };

      desktop = {
        wallpaper = {
          enabled = true;
          default.path = ./wallpaper/abstract-black-background.jpg;
        };
      };
    };
  };
}
