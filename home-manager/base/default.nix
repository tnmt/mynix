{ lib, ... }:
{
  imports = [
    ./programs
  ];

  home = {
    sessionVariables = {
      EDITOR = lib.mkDefault "vim";
    };
  };
}
