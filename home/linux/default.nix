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

  programs.home-manager.enable = true;
}
