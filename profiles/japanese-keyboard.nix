# Japanese keyboard remapping via keyd
# - CapsLock -> Left Control
# - Yen (¥) -> Backslash (\)
# - Ro (ろ) -> Grave (`)
# - Left Alt overload -> Muhenkan (IME off)
# - Right Alt overload -> Henkan (IME on)
{
  services.keyd = {
    enable = true;
    keyboards.default.settings = {
      main = {
        capslock = "leftcontrol";
        yen = "backslash";
        ro = "grave";
        leftalt = "overload(alt, muhenkan)";
        rightalt = "overload(alt, henkan)";
      };
    };
  };
}
