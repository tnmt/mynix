{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;

    withNodeJs = true;
    withPython3 = true;
    withRuby = false;

    initLua = builtins.readFile ./neovim/config/init.lua;

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
      lua-language-server
      pyright
      ruff
      typescript-language-server
    ];
  };

  # Place the lua config tree as-is. init.lua は programs.neovim.initLua 経由で投入する。
  xdg.configFile."nvim/lua" = {
    source = ./neovim/config/lua;
    recursive = true;
  };

  # Ensure backup directory exists
  home.file.".vimbackup/.keep".text = "";
}
