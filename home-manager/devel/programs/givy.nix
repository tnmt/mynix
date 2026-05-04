{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.givy;

  args = inst: [
    (lib.getExe pkgs.givy)
    "serve"
    inst.root
    "--port"
    (toString inst.port)
  ];
in
{
  options.programs.givy.instances = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule {
        options = {
          root = lib.mkOption {
            type = lib.types.str;
            description = "Directory served by this givy instance.";
          };
          port = lib.mkOption {
            type = lib.types.port;
            description = "TCP port the instance listens on.";
          };
        };
      }
    );
    default = {
      github = {
        root = "${config.home.homeDirectory}/ghq/github.com";
        port = 6271;
      };
    };
    description = ''
      Map of instance names to roots/ports. Each instance becomes a
      `givy-<name>` user service (systemd on Linux, launchd on Darwin),
      paired with a Caddy virtual host at `givy-<name>.lvh.me` on the
      system side.
    '';
  };

  config = {
    home.packages = [ pkgs.givy ];

    systemd.user.services = lib.mkIf pkgs.stdenv.hostPlatform.isLinux (
      lib.mapAttrs' (
        name: inst:
        lib.nameValuePair "givy-${name}" {
          Unit = {
            Description = "givy local git repository viewer (${name})";
            After = [ "network.target" ];
          };
          Service = {
            Type = "simple";
            ExecStart = lib.escapeShellArgs (args inst);
            Restart = "on-failure";
            RestartSec = 5;
          };
          Install.WantedBy = [ "default.target" ];
        }
      ) cfg.instances
    );

    launchd.agents = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin (
      lib.mapAttrs' (
        name: inst:
        lib.nameValuePair "givy-${name}" {
          enable = true;
          config = {
            ProgramArguments = args inst;
            KeepAlive = true;
            RunAtLoad = true;
          };
        }
      ) cfg.instances
    );
  };
}
