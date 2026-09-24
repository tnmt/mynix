{
  services.hyprsunset = {
    enable = true;
    settings = {
      profile = [
        {
          time = "07:00";
          identity = true;
        }
        {
          time = "20:00";
          temperature = 4000;
        }
      ];
    };
  };
}
