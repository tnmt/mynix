_: {
  dconf.settings."io/github/htkhiem/Euphonica/library" = {
    # 既定値に "Feat." / "+feat." / " loves " を足している。区切りは大文字小文字を
    # 区別するため、既定の "feat." では "Jazztronik Feat. VERBAL" や
    # "m-flo loves BoA" が分割されない。変更の反映には Euphonica の再起動が要る。
    artist-tag-delims = [
      ","
      ";"
      ":"
      "&"
      "/"
      "//"
      "\\"
      "\\\\"
      " X "
      "feat."
      " ft."
      "(ft."
      ",ft."
      "duet with"
      "special guest"
      "Feat."
      "+feat."
      " loves "
      " Loves "
    ];

    # 1 組のアーティスト名に区切り文字が含まれるもの。分割すると別人として
    # 一覧に並ぶので、先に例外として抜き出させる。
    artist-tag-delim-exceptions = [
      "Simon & Garfunkel"
      "Above & Beyond"
      "Earth, Wind & Fire"
      "Sun, Salt & Time"
      "This Day & Age"
      "Sons & Daughters"
      "Aun & HIDE"
      "VOLA & THE ORIENTAL MACHINE"
      "YASUAKI SHIMIZU & SAXOPHONETTES"
      "Glover, Crockett & Glover"
      "Stanley Turrentine & The Three Sounds"
      "Count Basie & Bill Evans"
      "Glenn Miller & Benny Goodman"
      "岸田教団&THE明星ロケッツ"
      "SUNDAY/SUNDAY"
    ];
  };
}
