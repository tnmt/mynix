{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.givy;
  inherit (import ../../../lib/givy.nix { inherit lib; }) instanceType;

  args = inst: [
    (lib.getExe pkgs.givy)
    "serve"
    inst.root
    "--port"
    (toString inst.port)
  ];
in
{
  options.programs.givy = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = cfg.instances != { };
      defaultText = lib.literalExpression "config.programs.givy.instances != { }";
      description = "Whether to run configured givy instances.";
    };

    instances = lib.mkOption {
      type = lib.types.attrsOf instanceType;
      default = { };
      example = lib.literalExpression ''
        {
          github = {
            root = config.home.homeDirectory + "/ghq/github.com";
            port = 6271;
          };
        }
      '';
      description = ''
        Map of instance names to roots/ports. Each instance becomes a
        `givy-<name>` user service (systemd on Linux, launchd on Darwin),
        paired with a Caddy virtual host at `givy-<name>.lvh.me` when the
        system-side givy profile is enabled.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.instances != { };
        message = "programs.givy.instances must not be empty when givy is enabled.";
      }
    ];

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
