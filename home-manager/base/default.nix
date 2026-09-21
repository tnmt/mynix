{ lib, ... }:
{
  imports = [
    ./ai
    ./programs
  ];

  home = {
    sessionVariables = {
      EDITOR = lib.mkDefault "vim";
    };
  };
}
