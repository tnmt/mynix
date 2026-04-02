{ ... }:
{
  imports = [
    ./programs
  ];

  home = {
    sessionVariables = {
      EDITOR = "nvim";
    };

    shellAliases = {
      vi = "nvim";
      vim = "nvim";
    };
  };
}
