# Keyboard remapping via kanata
# Common:
# - CapsLock -> Left Control
# - Left Super: hold -> Super / tap -> Muhenkan (IME off)
# - Right Super: hold -> Super / tap -> Henkan (IME on)
# JIS (built-in laptop):
# - Yen (¥) -> Backslash (\)
# - Ro (ろ) -> Grave (`)
{
  systemd.services.kanata-default = {
    serviceConfig = {
      Restart = "on-failure";
      RestartSec = 3;
    };
  };

  services.kanata = {
    enable = true;
    keyboards.default = {
      extraDefCfg = "process-unmapped-keys yes";
      config = ''
        (defsrc
          caps
          yen
          ro
          lmet
          rmet
        )

        (defalias
          lmet (tap-hold-press 200 200 muhenkan lmet)
          rmet (tap-hold-press 200 200 henkan rmet)
        )

        (deflayer default
          lctl
          \
          grv
          @lmet
          @rmet
        )
      '';
    };
  };
}
