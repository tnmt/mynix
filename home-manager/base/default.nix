{ ... }:
{
  imports = [
    ./options.nix
    ./programs
  ];

  home = {
    sessionVariables = {
      EDITOR = "nvim";
    };
  };
}
