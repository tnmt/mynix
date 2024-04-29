{ ... }: {
  imports = [
    ./programs
  ];

  home = {
    sessionVariables = {
      EDITOR = "nvim";
    };
  };
}
