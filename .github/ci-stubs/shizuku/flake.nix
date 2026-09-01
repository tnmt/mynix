{
  description = "CI stand-in for the private tnmt/shizuku input";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { nixpkgs, ... }:
    {
      packages = nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-darwin" ] (system: {
        default = nixpkgs.legacyPackages.${system}.hello;
      });
    };
}
