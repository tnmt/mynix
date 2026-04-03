{ pkgs, ... }:
{
  services.mysql = {
    enable = true;
    package = pkgs.mysql80;
    settings.mysqld = {
      bind-address = "127.0.0.1";
      key_buffer_size = "16M";
      max_binlog_size = "100M";
    };
  };
}
