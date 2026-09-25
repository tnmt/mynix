{
  forAllSystems,
  pkgsFor,
  self,
}:
forAllSystems (
  system:
  let
    pkgs = pkgsFor system;
    rebuildCmd = if pkgs.lib.hasSuffix "darwin" system then "darwin" else "os";
    switch = pkgs.writeShellApplication {
      name = "switch";
      runtimeInputs = [ pkgs.nh ];
      text = ''
        host="''${HOSTNAME:-$(uname -n)}"
        host="''${host%%.*}"
        exec nh ${rebuildCmd} switch . -H "$host" "$@"
      '';
    };
  in
  {
    # Extra args after `--` pass through to nh.
    switch = {
      type = "app";
      program = "${switch}/bin/switch";
      meta.description = "Rebuild & activate current host (auto-detect NixOS/Darwin)";
    };
  }
  // pkgs.lib.optionalAttrs (system == "x86_64-linux") {
    dahlia-vm = {
      type = "app";
      program = "${self.nixosConfigurations.dahlia.config.system.build.vm}/bin/run-dahlia-vm";
      meta.description = "Run dahlia NixOS VM";
    };
  }
)
