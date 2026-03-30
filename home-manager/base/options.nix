# Custom options for host classification
# Equivalent to chezmoi's .chezmoi.toml.tmpl data variables
{ lib, ... }:
{
  options.custom = {
    desktop = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable desktop/GUI programs and configs";
    };
    development = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable development tools and language servers";
    };
    email = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "User email for git and other tools";
    };
    name = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "User display name for git and other tools";
    };
  };
}
