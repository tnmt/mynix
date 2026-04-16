# Japanese keyboard remapping via kanata
# - CapsLock -> Left Control
# - Yen (¥) -> Backslash (\)
# - Ro (ろ) -> Grave (`)
# - Left Alt: hold -> Alt / tap -> Muhenkan (IME off)
# - Right Alt: hold -> Alt / tap -> Henkan (IME on)
{
  services.kanata = {
    enable = true;
    keyboards.default = {
      extraDefCfg = "process-unmapped-keys yes";
      config = ''
        (defsrc
          caps
          yen
          ro
          lalt
          ralt
        )

        (defalias
          lalt (tap-hold 200 200 muhenkan lalt)
          ralt (tap-hold 200 200 henkan ralt)
        )

        (deflayer default
          lctl
          \
          grv
          @lalt
          @ralt
        )
      '';
    };
  };
}
