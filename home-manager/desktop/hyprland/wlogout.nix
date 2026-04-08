{ pkgs, theme, ... }:
let
  wlogoutIcons = "${pkgs.wlogout}/share/wlogout/icons";
in
{
  home.file.".config/wlogout/style.css".text = ''
    * {
      background-image: none;
      box-shadow: none;
      font-family: "Noto Sans CJK JP";
    }

    window {
      background-color: rgba(29, 32, 47, 0.9);
    }

    button {
      border-radius: 8px;
      border: 1px solid ${theme.color8};
      color: ${theme.foreground};
      background-color: ${theme.background};
      background-repeat: no-repeat;
      background-position: center 30%;
      background-size: 64px;
      font-size: 14px;
      margin: 5px;
    }

    button:focus, button:active, button:hover {
      background-color: ${theme.color8};
      border-color: ${theme.accent};
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
