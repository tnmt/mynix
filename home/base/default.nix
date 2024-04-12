{ ... }: {
  imports = [
    ./programs
    ./terminal
  ];

  home = {
    sessionVariables = {
      EDITOR = "nvim";
    };
  };
}
