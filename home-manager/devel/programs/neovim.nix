{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;

    withNodeJs = true;
    withPython3 = true;
    withRuby = false;

    extraPackages = with pkgs; [
      # For treesitter compilation
      gcc
      gnumake
      tree-sitter

      # Used by telescope
      ripgrep
      fd

      # Nix
      nil
      nixfmt

      # TOML
      taplo

      # LSP servers (managed by Nix instead of mason)
      gopls
      ruby-lsp
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
