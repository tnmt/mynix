{
  forAllSystems,
  formattersFor,
  pkgsFor,
}:
{
  devShells = forAllSystems (
    system:
    let
      pkgs = pkgsFor system;
      formatters = formattersFor pkgs;
      updateInput = pkgs.writeShellApplication {
        name = "update-input";
        runtimeInputs = [ pkgs.nix ];
        text = ''
          if (( $# != 2 )); then
            echo "usage: update-input <input> <url>" >&2
            exit 2
          fi
          exec nix flake lock --override-input "$1" "$2"
        '';
      };
    in
    {
      default = pkgs.mkShell {
        packages =
          (with pkgs; [
            nh
            cachix
          ])
          ++ formatters
          ++ [ updateInput ];
      };
    }
  );

  formatter = forAllSystems (
    system:
    let
      pkgs = pkgsFor system;
      formatters = formattersFor pkgs;
    in
    pkgs.writeShellApplication {
      name = "format";
      runtimeInputs = formatters ++ [ pkgs.treefmt ];
      text = ''
        exec treefmt --config-file ${../treefmt.toml} "$@"
      '';
    }
  );
}
