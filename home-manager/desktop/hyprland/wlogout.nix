{
  pkgs,
  theme,
  ...
}:
let
  fonts = import ../fonts.nix;
  wlogoutIcons = "${pkgs.wlogout}/share/wlogout/icons";
in
{
  home.file.".config/wlogout/style.css".text = ''
    * {
      background-image: none;
      box-shadow: none;
      font-family: "${fonts.sans}";
    }

    window {
      background-color: alpha(${theme.color0}, 0.9);
    }

    button {
      border-radius: 40px;
      border: none;
      color: ${theme.foreground};
      background-color: transparent;
      background-repeat: no-repeat;
      background-position: center 30%;
      background-size: 64px;
      font-size: 14px;
      margin: 10px;
    }

    button:focus, button:active, button:hover {
      background-color: ${theme.bg_highlight};
      outline-style: none;
    }

    #lock {
      background-image: image(url("${wlogoutIcons}/lock.png"));
    }

    #logout {
      background-image: image(url("${wlogoutIcons}/logout.png"));
    }

    #suspend {
      background-image: image(url("${wlogoutIcons}/suspend.png"));
    }

    #hibernate {
      background-image: image(url("${wlogoutIcons}/hibernate.png"));
    }

    #shutdown {
      background-image: image(url("${wlogoutIcons}/shutdown.png"));
    }

    #reboot {
      background-image: image(url("${wlogoutIcons}/reboot.png"));
    }
  '';
}
