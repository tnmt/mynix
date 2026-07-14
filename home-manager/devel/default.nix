{ ... }:
{
  imports = [
    ./programs
  ];

  home = {
    # EDITOR=nvim comes from programs.neovim.defaultEditor (devel/programs/neovim.nix)
    sessionVariables = {
      GOPATH = "$HOME/.go";
    };

    shellAliases = {
      vi = "nvim";
      vim = "nvim";
    };
  };

  programs.zsh.envExtra = ''
    export PATH="''${KREW_ROOT:-$HOME/.krew}/bin:$GOPATH/bin:$HOME/.cache/.bun/bin:$HOME/.npm-global/bin:$HOME/.cargo/bin:$PATH"
  '';
}
