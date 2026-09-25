# Keyboard remapping via kanata
# Common:
# - CapsLock -> Left Control
# - Left Super: hold -> Super / tap -> Muhenkan (IME off)
# - Right Super: hold -> Super / tap -> Henkan (IME on)
# JIS keys (applies to all keyboards; no-op on US layouts without these keys):
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
          ;; kanata parses the word "yen" as KEY_BACKSLASH, not the physical Yen key; only the ¥ glyph maps to KEY_YEN
          ¥
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
