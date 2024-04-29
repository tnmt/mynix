{ pkgs
, ...
}: {

  imports = [
    ../base
  ];

  home = {
    username = "tnmt";
    homeDirectory = "/home/tnmt";

    stateVersion = "22.11";
  };

  # Define packages supported in only linux
  home.packages = with pkgs; [
  ];

  programs.home-manager.enable = true;
}