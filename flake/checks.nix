{
  forAllSystems,
  inputs,
  pkgsFor,
  self,
}:
forAllSystems (
  system:
  let
    pkgs = pkgsFor system;
    mynixLib = import ../lib { inherit inputs; };
    platformAssertions =
      assert mynixLib.mkHomeDirectory "test" "x86_64-linux" == "/home/test";
      assert mynixLib.mkHomeDirectory "test" "x86_64-darwin" == "/Users/test";
      assert mynixLib.mkHomeDirectory "test" "aarch64-darwin" == "/Users/test";
      true;
    givyAssertions =
      if system == "x86_64-linux" then
        assert !self.nixosConfigurations.sunflower.config.home-manager.users.tnmt.programs.givy.enable;
        assert self.nixosConfigurations.dahlia.config.home-manager.users.tnmt.programs.givy.enable;
        true
      else
        true;
  in
  {
    architecture =
      assert platformAssertions;
      assert givyAssertions;
      pkgs.runCommand "mynix-architecture-check" { } "touch $out";

    shell = pkgs.runCommand "mynix-shellcheck" { nativeBuildInputs = [ pkgs.shellcheck ]; } ''
      find ${self.outPath}/.githooks ${self.outPath}/home-manager -type f \
        \( -name '*.sh' -o -path '*/scripts/*' -o -path '*/.githooks/*' \) \
        ! -name '*.nix' \
        -print0 | xargs -0 shellcheck
      touch "$out"
    '';
  }
)
