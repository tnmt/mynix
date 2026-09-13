{ lib }:
{
  instanceType = lib.types.submodule {
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
  };
}
