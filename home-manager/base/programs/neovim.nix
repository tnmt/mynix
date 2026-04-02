{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    withNodeJs = true;
    withPython3 = true;
    withRuby = false;

    extraPackages = with pkgs; [
      # For treesitter compilation
      gcc
      gnumake

      # Used by telescope
      ripgrep
      fd

      # Nix
      nil
      nixfmt
    ];
  };

  # Place the lua config tree as-is. Lazy.nvim + mason manage plugins at runtime.
  xdg.configFile."nvim" = {
    source = ./neovim/config;
    recursive = true;
  };

  # Ensure backup directory exists
  home.file.".vimbackup/.keep".text = "";
}
