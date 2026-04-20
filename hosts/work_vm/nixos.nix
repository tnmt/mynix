{ username, ... }:
{
  imports = [
    ../../profiles/nixos/openstack.nix
    ../../modules/nixos/core/home-manager.nix
  ];

  home-manager.users."${username}" = import ./home-manager.nix;

  users.users.tnmt.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC8DvXjmY4hBEaAxetwnbdRZYtyqMzsq5OXLDakNfwgNrezVJm6sp8pPtkPOCKpZ+Zur+94WMD1Xv3MYbEYaRsFd3IaqEJZLM7DTOVqv+lvTDotrm9HXEWY/7YwJc5nJTyhMvFX/jI6Y993DtJ4+VOH+PNDoP1DeR1DSmObXjFERnoCEMYHwBiSpqQSWxh1Vjb99WwaYi/oHg9PKfjtuW0FeKU4Ak0oNNhYS6M4vQxMNPccU2z43OfYdOF5uqO4TLF/TX46ATMNUpCbWvwmuM7PxxYu4yl9byOJub0/jJfqkttAEOCFuBcq6oqy6ZlrYJTNiUze/U2oqD4hh+2SVMBbqljVmN5fC2jxQrtxmA0dNTGh+RGv9/bly/AVsFsIm0bm/JNqsSFQsJ8AdQsh6uVmSBTryqTDib3RARPmaRDLgSwPruIwg5sY82j1/6/nlgP5rOZ/30UW1uQkvofKiZzVPQJ9gQzwd1zudMXT2KdV0eeSGvg5mVIRyXX6JV8Ko8Mz6MIQiqRkouQPjcWqc05xsGMLIInDH1ZGbrvCFa6OcoMNlrd8dQszPK9W9cy3OaruXIncfiYmvP4TfNkxo1RAXcPHN5839kKhTIrmpgSmovd1W5yYK2pnQU0HgBKJll9xc6Mh0p+GNK3K6j+9HSri3P01wu5LFHchs773KY+OEw== tsunematsu@pepabo.com"
  ];
}
