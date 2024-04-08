{ pkgs
, ...
}: {

  imports = [
    ../base
  ];

  home = {
    username = "tnmt";
    homeDirectory = "/home/tnmt";

    stateVersion = "23.11";
  };

  # Define packages supported in only linux
  home.packages = with pkgs; [
    # gcc
    gcc
  ];

  programs.home-manager.enable = true;
}
