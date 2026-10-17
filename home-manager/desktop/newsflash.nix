{ pkgs, ... }:
let
  fonts = import ./fonts.nix;

  # 記事ビューの font_style = Serif を前提とする (~/.config/news-flash/newsflash_gtk.json)。
  # Newsflash は Serif のとき Noto Serif CJK を名指しで探し、フォント設定では差し替えられない。
  # この app の fontconfig だけで Noto Serif CJK を隠し、汎用 serif に落として fonts.sans を使わせる。
  # Noto Sans CJK は Regular だと 20px 前後で「半」の斜画が潰れて「牛」に見えるため、Medium に上げる。
  fontconfig = pkgs.writeText "newsflash-fonts.conf" ''
    <?xml version="1.0"?>
    <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
    <fontconfig>
      <include ignore_missing="yes">/etc/fonts/fonts.conf</include>
      <selectfont>
        <rejectfont><glob>*/NotoSerifCJK*</glob></rejectfont>
      </selectfont>
      <match target="pattern">
        <test name="family" qual="any"><string>serif</string></test>
        <edit name="family" mode="prepend_first" binding="strong"><string>${fonts.sans}</string></edit>
      </match>
      <match target="pattern">
        <test name="family" qual="any"><string>${fonts.sans}</string></test>
        <test name="weight" compare="less_eq"><const>regular</const></test>
        <edit name="weight" mode="assign" binding="strong"><const>medium</const></edit>
      </match>
    </fontconfig>
  '';

  newsflash = pkgs.symlinkJoin {
    name = "newsflash-${pkgs.newsflash.version}";
    paths = [ pkgs.newsflash ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/io.gitlab.news_flash.NewsFlash --set FONTCONFIG_FILE ${fontconfig}
    '';
  };
in
{
  home.packages = [ newsflash ];
}
