{ inputs, username, ... }:
{
  hardware.uinput.enable = true;
  users.groups.uinput.members = [ username ];
  users.groups.input.members = [ username ];

  imports = [ inputs.xremap.nixosModules.default ];
  services.xremap = {
    userName = username;
    serviceMode = "user";
    config = {
      # CapsLock→Ctrl is handled by keyd at evdev level
      keymap = [
        {
          name = "Better Backspace";
          exact_match = true;
          application = {
            not = [
              "Alacritty"
              "kitty"
              "org.wezfurlong.wezterm.org.wezfurlong.wezterm"
            ];
          };
          remap = {
            C-h = "Backspace";
          };
        }
      ];
    };
  };
}
