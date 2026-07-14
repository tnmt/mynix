{ ... }:
{
  imports = [ ../../common/nix-settings.nix ];

  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep 5 --keep-since 7d";
    };
  };

  nix.settings = {
    auto-optimise-store = true;
    trusted-users = [
      "@wheel"
      "nixremote"
    ];
    download-buffer-size = 256 * 1024 * 1024; # 256MB
  };
}
