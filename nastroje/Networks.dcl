Networks //nazov dcl

: dialog
{
  //nazov dialogu
  label = "Nastavenie sieti";

  //definovanie stlpca
  : boxed_column
  {
    label = "Siete";

    //prvy riadok - vsetky ciary
    : row
    {
        : toggle
        {
          key = "sieteVsetkyCiary";
          label = "Vsetky ciary";
          width = 30;
        }
        : button
        {
          key = "sieteVsetkyCiaryInfo";
          label = "Info";
        }
    }

    //druhy riadok - ciary hranic
    : row
    {
        : toggle
        {
          key = "sieteCiaryHranic";
          label = "Ciary hranic";
          width = 30;
        }
        : button
        {
          key = "sieteCiaryHranicInfo";
          label = "Info";
          width = 10;
        }
    }

    //treti riadok - ciary zvodidla
    : row
    {
        : toggle
        {
          key = "sieteCiaryZvodidla";
          label = "Ciary zvodidla";
          width = 30;
        }
        : button
        {
          key = "sieteCiaryZvodidlaInfo";
          label = "Info";
          width = 10;
        }
    }

    //stvrti riadok - ciary vodovodu
    : row
    {
        : toggle
        {
          key = "sieteCiaryVodovodu";
          label = "Ciary vodovodu";
          width = 30;
        }
        : button
        {
          key = "sieteCiaryVodovoduInfo";
          label = "Info";
          width = 10;
        }
    }

    //piati riadok - ciary kanalizacie
    : row
    {
        : toggle
        {
          key = "sieteCiaryKanalizacie";
          label = "Ciary kanalizacie";
          width = 30;
        }
        : button
        {
          key = "sieteCiaryKanalizacieInfo";
          label = "Info";
          width = 10;
        }
    }

    //siesti riadok - ciary hrdloveho vedenia
    : row
    {
        : toggle
        {
          key = "sieteCiaryHrdlovehoVedenia";
          label = "Ciary hrdloveho vedenia";
          width = 30;
        }
        : button
        {
          key = "sieteCiaryHrdlovehoVedeniaInfo";
          label = "Info";
          width = 10;
        }
    }

    //siedmi riadok - ciary plynovodu
    : row
    {
        : toggle
        {
          key = "sieteCiaryPlynovodu";
          label = "Ciary plynovodu";
          width = 30;
        }
        : button
        {
          key = "sieteCiaryPlynovoduInfo";
          label = "Info";
          width = 10;
        }
    }

    //osmi riadok - ciary tepelneho potrubia
    : row
    {
        : toggle
        {
          key = "sieteCiaryTepelnehoPotrubia";
          label = "Ciary tepelneho potrubia";
          width = 30;
        }
        : button
        {
          key = "sieteCiaryTepelnehoPotrubiaInfo";
          label = "Info";
          width = 10;
        }
    }

    //deviati riadok - ciary siloveho vedenia
    : row
    {
        : toggle
        {
          key = "sieteCiarySilovehoVedenia";
          label = "Ciary siloveho vedenia";
          width = 30;
        }
        : button
        {
          key = "sieteCiarySilovehoVedeniaInfo";
          label = "Info";
          width = 10;
        }
    }

    //desiati riadok - ciary slaboprudoveho vedenia
    : row
    {
        : toggle
        {
          key = "sieteCiarySlaboprudehoVedenia";
          label = "Ciary slaboprudoveho vedenia";
          width = 30;
        }
        : button
        {
          key = "sieteCiarySlaboprudehoVedeniaInfo";
          label = "Info";
          width = 10;
        }
    }

    //jedenasti riadok - ciary vody a vrstvenice
    : row
    {
        : toggle
        {
          key = "sieteCiaryVodaVrstvenice";
          label = "Ciary vod a vrtvenic";
          width = 30;
        }
        : button
        {
          key = "sieteCiaryVodaVrstveniceInfo";
          label = "Info";
          width = 10;
        }
    }

  }

  //riadok s poznamkou
  : boxed_row
  {
    label = "Poznamka";
    : text { label = "Ciary sa nacitaju len do aktualneho vykresu."; }  
  }

  //predposledny riadok dialogu s tlacidlami
  : row
  {
    //tlacidlo ulozit
    : button
    {
      key = "tlacidloOznacitVsetko";
      label = "Oznacit vsetko";
    }  

    //tlacidlo zavriet
    : button
    {
      key = "tlacidloOdznacitVsetko";
      label = "Odznacit vsetko";
    }
  }

  //posledny riadok dialogu s tlacidlami
  : row
  {
    //tlacidlo ulozit
    : button
    {
      key = "nacitat";
      label = "Nacitat";
      is_default = true;
      mnemonic = "N";
    }  

    //tlacidlo zavriet
    : button
    {
      key = "cancel";
      label = "Zavriet";
      is_cancel = true;
      mnemonic = "Z";
    }
  }
}

/////// DIALOGOVE OKNO INFO VSETKY SIETE ///////

SieteVsetkyCiaryInfo

: dialog
{
  label = "Informacie o vsetkych sietach";
  : boxed_row
  {
    label = "Poznamka";
    : text{ label = "Do suboru sa nacitajaju vsetky ciary podla ISO 128."; }
  }

  : button
  {
    key = "zatvoritInfo";
    label = "OK";
    is_default = true;
    is_cancel = true;
    width = 15;
    fixed_width = true;
    alignment = centered;
  }
}

/////// DIALOGOVE OKNO INFO CIARY HRANIC ///////

SieteCiaryHranicInfo

: dialog
{
  label = "Informacie o ciarach hranic";
  : row
  {
    : boxed_column
    {
      label = "Kod ciary";
      : text { label = "201"; }
      : text { label = "203"; }
      : text { label = "204"; }
      : text { label = "205"; }
      : text { label = "206"; }
      : text { label = "207L"; }
      : text { label = "207R"; }
      : text { label = "208"; }
      : text { label = "209"; }
      : text { label = "210L"; }
      : text { label = "210R"; }
      : text { label = "211"; }
      : text { label = "211L"; }
      : text { label = "211R"; }
      : text { label = "212L"; }
      : text { label = "212R"; }
      : text { label = "213"; }
      : text { label = "213L"; }
      : text { label = "213R"; }
      : text { label = "214L"; }
    }
    : boxed_column
    {
      label = "Popis ciary";
      : text { label = "Hranica statu"; }
      : text { label = "Hranica kraja"; }
      : text { label = "Hranica okresu"; }
      : text { label = "Hranica obce"; }
      : text { label = "Hranica katastralneho uzemia"; }
      : text { label = "Hranica zastaveneho uzemia obce pre ucely ochrany PPF"; }
      : text { label = "Hranica zastaveneho uzemia obce pre ucely ochrany PPF"; }
      : text { label = "Rozhranie presnosti mapovania"; }
      : text { label = "Plet bez rozlisenia druhu"; }
      : text { label = "Dreveny plot (lavy)"; }
      : text { label = "Dreveny plot (pravy)"; }
      : text { label = "Dreveny plot spoluvlastnictva"; }
      : text { label = "Dreveny plot spoluvlastnictva (lavy)"; }
      : text { label = "Dreveny plot spoluvlastnictva (pravy)"; }
      : text { label = "Droteny kovovy plot vlastnictva z jednej strany (lava)"; }
      : text { label = "Droteny kovovy plot vlastnictva z jednej strany (prava)"; }
      : text { label = "Droteny kovovy plot spoluvlastnictva"; }
      : text { label = "Droteny kovovy plot spoluvlastnictva (lavy)"; }
      : text { label = "Droteny kovovy plot spoluvlastnictva (pravy)"; }
      : text { label = "Zivy plot vlastnictva z jednej strany (lava)"; }
    }
    : boxed_column
    {
      label = "Kod ciary";
      : text { label = "214R"; }
      : text { label = "215"; }
      : text { label = "215L"; }
      : text { label = "215R"; }
      : text { label = "216L"; }
      : text { label = "216R"; }
      : text { label = "217"; }
      : text { label = "217L"; }
      : text { label = "217R"; }
      : text { label = "218"; }
      : text { label = "220"; }
      : text { label = "221"; }
      : text { label = "222"; }
      : text { label = "223"; }
      : text { label = "224"; }
      : text { label = "225"; }
      : text { label = "226"; }
      : text { label = "227"; }
      : text { label = ""; }
      : text { label = ""; }
    }
    : boxed_column
    {
      label = "Popis ciary";
      : text { label = "Zivy plot vlastnictva z jednej strany (prava)"; }
      : text { label = "Zivy plost spoluvlastnictva"; }
      : text { label = "Zivy plost spoluvlastnictva (lavy)"; }
      : text { label = "Zivy plost spoluvlastnictva (lavy)"; }
      : text { label = "Ochranny mur vlastnicva z jednej strany (lava)"; }
      : text { label = "Ochranny mur vlastnicva z jednej strany (peav)"; }
      : text { label = "Ochranny mur spoluvlastnictva"; }
      : text { label = "Ochranny mur spoluvlastnictva (lavy)"; }
      : text { label = "Ochranny mur spoluvlastnictva (pravy)"; }
      : text { label = "Slucka"; }
      : text { label = "Hranica vlastnictva zhora neviditelna"; }
      : text { label = "Hranica pohybliva nestala"; }
      : text { label = "Hranica neznatelna"; }
      : text { label = "Hranica chraneneho uzemia"; }
      : text { label = "Hranica ochranneho pasma"; }
      : text { label = "Hranica technickeho ochranneho pasma"; }
      : text { label = "Hranica podzemna"; }
      : text { label = "Hranica sporna"; }
      : text { label = ""; }
      : text { label = ""; }
    }
  }

  : button
  {
    key = "zatvoritInfo";
    label = "OK";
    is_default = true;
    is_cancel = true;
    width = 15;
    fixed_width = true;
    alignment = centered;
  }
  
}

/////// DIALOGOVE OKNO INFO CIARY ZVODIDLA ///////

SieteCiaryZvodidlaInfo

: dialog
{
  label = "Informacie o ciarach zvodidla";
  : row
  {
    : boxed_column
    {
      label = "Kod ciary";
      : text { label = "529AL"; }
      : text { label = "529AR"; }
      : text { label = "529B"; }
      : text { label = "530"; }
      : text { label = "612"; }
    }
    : boxed_column
    {
      label = "Popis ciary";
      : text { label = "Zvodidlo lavostranne"; }
      : text { label = "Zvodidlo pravostranne"; }
      : text { label = "Zvodidlo zdvojene"; }
      : text { label = "Zabradlie typ 1"; }
      : text { label = "Zabradlie typ 2"; }
    } 
  }

  : button
  {
    key = "zatvoritInfo";
    label = "OK";
    is_default = true;
    is_cancel = true;
    width = 15;
    fixed_width = true;
    alignment = centered;
  }
}

/////// DIALOGOVE OKNO INFO CIARY VODOVODU ///////

SieteCiaryVodovoduInfo

: dialog
{
  label = "Informacie o ciarach vodovodu";
  : row
  {
    : boxed_column
    {
      label = "Kod ciary";
      : text { label = "615A"; }
      : text { label = "615B"; }
      : text { label = "615C"; }
      : text { label = "616A"; }
      : text { label = "616B"; }
      : text { label = "616C"; }
      : text { label = "617A"; }
      : text { label = "617B"; }
      : text { label = "617C"; }
    }
    : boxed_column
    {
      label = "Popis ciary";
      : text { label = "Vodovodne potrubie bez rozlišsenia druhu nadzemne"; }
      : text { label = "Vodovodne potrubie bez rozlisenia druhu podzemne"; }
      : text { label = "Vodovodne potrubie bez rozlisenia druhu podzemne priblizne"; }
      : text { label = "Vodovodne potrubie pitnej vody nadzemne"; }
      : text { label = "Vodovodne potrubie pitnej vody podzemne"; }
      : text { label = "Vodovodne potrubie pitnej vody podzemne priblizne"; }
      : text { label = "Vodovodne potrbuie uzitkovej vody nadzemne"; }
      : text { label = "Vodovodne potrbuie uzitkovej vody podzemne"; }
      : text { label = "Vodovodne potrbuie uzitkovej vody  podzemne priblizne"; }
    } 
  }

  : button
  {
    key = "zatvoritInfo";
    label = "OK";
    is_default = true;
    is_cancel = true;
    width = 15;
    fixed_width = true;
    alignment = centered;
  }
}

/////// DIALOGOVE OKNO INFO CIARY KANALIZACIE ///////

SieteCiaryKanalizacieInfo

: dialog
{
  label = "Informacie o ciarach kanalizacie";
  : row
  {
    : boxed_column
    {
      label = "Kod ciary";
      : text { label = "623A"; }
      : text { label = "623B"; }
      : text { label = "623C"; }
      : text { label = "624A"; }
      : text { label = "624B"; }
      : text { label = "624C"; }
      : text { label = "625A"; }
      : text { label = "625B"; }
      : text { label = "625C"; }
      : text { label = "626A"; }
    }
    : boxed_column
    {
      label = "Popis ciary";
      : text { label = "Kanalizacna stoka bez rozlisenia druhu nadzemna"; }
      : text { label = "Kanalizacna stoka bez rozlisenia druhu podzemna"; }
      : text { label = "Kanalizacna stoka bez rozlisenia druhu podzemna priblizna"; }
      : text { label = "Jednotna kanalizacia nadzemna"; }
      : text { label = "Jednotna kanalizacia podzemna"; }
      : text { label = "Jednotna kanalizacia podzemna priblizna"; }
      : text { label = "Odlahcovacia stoka jednodnej kanalizacie nadzemna"; }
      : text { label = "Odlahcovacia stoka jednodnej kanalizacie podzemna"; }
      : text { label = "Odlahcovacia stoka jednodnej kanalizacie podzemna priblizna"; }
      : text { label = "Dazdova kanalizacia nadzemna"; }
    } 
    : boxed_column
    {
      label = "Kod ciary";
      : text { label = "626B"; }
      : text { label = "626C"; }
      : text { label = "627A"; }
      : text { label = "627B"; }
      : text { label = "627C"; }
      : text { label = "628A"; }
      : text { label = "628B"; }
      : text { label = "628C"; }
      : text { label = "629A"; }
      : text { label = "629B"; }
    }
    : boxed_column
    {
      label = "Popis ciary";
      : text { label = "Dazdova kanalizacia podzemna"; }
      : text { label = "Dazdova kanalizacia podzemna priblizna"; }
      : text { label = "Splaskova kanalizacia nadzemna"; }
      : text { label = "Splaskova kanalizacia podzemna"; }
      : text { label = "Splaskova kanalizacia podzemna priblizna"; }
      : text { label = "Kanalizacia priemyselnych odpadov nadzemna"; }
      : text { label = "Kanalizacia priemyselnych odpadov podzemna"; }
      : text { label = "Kanalizacia priemyselnych odpadov podzemna priblizna"; }
      : text { label = "Vytlacne kalove potrubie nadzemna"; }
      : text { label = "Vytlacne kalove potrubie podzemna"; }
    }
    : boxed_column
    {
      label = "Kod ciary";
      : text { label = "629C"; }
      : text { label = ""; }
      : text { label = ""; }
      : text { label = ""; }
      : text { label = ""; }
      : text { label = ""; }
      : text { label = ""; }
      : text { label = ""; }
      : text { label = ""; }
      : text { label = ""; }
    }
    : boxed_column
    {
      label = "Popis ciary";
      : text { label = "Vytlacne kalove potrubie podzemne priblizne"; }
      : text { label = ""; }
      : text { label = ""; }
      : text { label = ""; }
      : text { label = ""; }
      : text { label = ""; }
      : text { label = ""; }
      : text { label = ""; }
      : text { label = ""; }
      : text { label = ""; }
    }
  }

  : button
  {
    key = "zatvoritInfo";
    label = "OK";
    is_default = true;
    is_cancel = true;
    width = 15;
    fixed_width = true;
    alignment = centered;
  }
}

/////// DIALOGOVE OKNO INFO CIARY HRDLOVEHO VEDENIA ///////

SieteCiaryHrdlovehoVedeniaInfo

: dialog
{
  label = "Informacie o ciarach hrdloveho vedenia";
  : row
  {
    : boxed_column
    {
      label = "Kod ciary";
      : text { label = "630A"; }
      : text { label = "630B"; }
      : text { label = "630C"; }
      : text { label = "630D"; }
      : text { label = "630E"; }
      : text { label = "630F"; }
      : text { label = "631A"; }
      : text { label = "631B"; }
      : text { label = "631C"; }
      : text { label = "631D"; }
    }
    : boxed_column
    {
      label = "Popis ciary";
      : text { label = "Hrdlove vedenie liatinove - plna ciara"; }
      : text { label = "Hrdlove vedenie liatinove dazdove - plna ciara"; }
      : text { label = "Hrdlove vedenie kameninove - plna ciara"; }
      : text { label = "Hrdlove vedenie kameninove dazdove - plna ciara"; }
      : text { label = "Hrdlove vedenie betonove - plna ciara"; }
      : text { label = "Hedlove vedenie plastove - plna ciara"; }
      : text { label = "Hrdlove vedenie liatinove - ciarkovana ciara"; }
      : text { label = "Hrdlove vedenie liatinove dazdove - ciarkovana ciara"; }
      : text { label = "Hrdlove vedenie kameninove - ciarkovana ciara"; }
      : text { label = "Hrdlove vedenie kameninove dazdove - ciarkovana ciara"; }
    }
    : boxed_column
    {
      label = "Kod ciary";
      : text { label = "631E"; }
      : text { label = "631F"; }
      : text { label = ""; }
      : text { label = ""; }
      : text { label = ""; }
      : text { label = ""; }
      : text { label = ""; }
      : text { label = ""; }
      : text { label = ""; }
      : text { label = ""; }
    }
    : boxed_column
    {
      label = "Popis ciary";
      : text { label = "Hrdlove vedenie betonove - ciarkovana ciara"; }
      : text { label = "Hedlove vedenie plastove - ciarkovana ciara"; }
      : text { label = ""; }
      : text { label = ""; }
      : text { label = ""; }
      : text { label = ""; }
      : text { label = ""; }
      : text { label = ""; }
      : text { label = ""; }
      : text { label = ""; }
    }
  }

  : button
  {
    key = "zatvoritInfo";
    label = "OK";
    is_default = true;
    is_cancel = true;
    width = 15;
    fixed_width = true;
    alignment = centered;
  }
}

/////// DIALOGOVE OKNO INFO CIARY PLYNOVODU ///////

SieteCiaryPlynovoduInfo

: dialog
{
  label = "Informacie o ciarach plynovodu";
  : row
  {
    : boxed_column
    {
      label = "Kod ciary";
      : text { label = "632A"; }
      : text { label = "632B"; }
      : text { label = "632C"; }
      : text { label = "633A"; }
      : text { label = "633B"; }
      : text { label = "633C"; }
      : text { label = "634A"; }
      : text { label = "634B"; }
      : text { label = "634C"; }
      : text { label = "635A"; }
    }
    : boxed_column
    {
      label = "Popis ciary";
      : text { label = "Plynovodne potrubie bez rozlisenia tlaku nadzemne"; }
      : text { label = "Plynovodne potrubie bez rozlisenia tlaku podzemne"; }
      : text { label = "Plynovodne potrubie bez rozlisenia tlaku podzemne priblizne"; }
      : text { label = "Plynovodne potrubie nizkotlakove nadzemne"; }
      : text { label = "Plynovodne potrubie nizkotlakove podzemne"; }
      : text { label = "Plynovodne potrubie nizkotlakove podzemne priblizne"; }
      : text { label = "Plynovodne potrubie strednotlakove nadzemne"; }
      : text { label = "Plynovodne potrubie strednotlakove podzemne"; }
      : text { label = "Plynovodne potrubie strednotlakove podzemne priblizne"; }
      : text { label = "Plynovodne potrubie vysokotlakove nadzemne"; }
    }
    : boxed_column
    {
      label = "Kod ciary";
      : text { label = "635B"; }
      : text { label = "635C"; }
      : text { label = "636A"; }
      : text { label = "636B"; }
      : text { label = "636C"; }
      : text { label = "637A"; }
      : text { label = "637B"; }
      : text { label = "637C"; }
      : text { label = ""; }
      : text { label = ""; }
    }
    : boxed_column
    {
      label = "Popis ciary";
      : text { label = "Plynovodne potrubie vysokotlakove podzemne"; }
      : text { label = "Plynovodne potrubie vysokotlakove podzemne priblizne"; }
      : text { label = "Potrubie technickeho plynu nadzemne"; }
      : text { label = "Potrubie technickeho plynu podzemne"; }
      : text { label = "Potrubie technickeho plynu pdozemne priblizne"; }
      : text { label = "Potrubie stlaceneho vzduchu nadzemne"; }
      : text { label = "Potrubie stlaceneho vzduchu podzemne"; }
      : text { label = "Potrubie stlaceneho vzduchu podzemne priblizne"; }
      : text { label = ""; }
      : text { label = ""; }
    }
  }

  : boxed_row
  {
    label = "Poznamka";
    : text { label = "Nizkotlakove: do 5 kPa | Strednotlakove: 5 kPa - 400 kPa | Vysokotlakove: 400 kPa - 1,6 MPa"; }
  }

  : button
  {
    key = "zatvoritInfo";
    label = "OK";
    is_default = true;
    is_cancel = true;
    width = 15;
    fixed_width = true;
    alignment = centered;
  }
}

/////// DIALOGOVE OKNO INFO CIARY TEPELNEHO POTRUBIA ///////

SieteCiaryTepelnehoPotrubiaInfo

: dialog
{
  label = "Informacie o ciarach tepelneho potrubia";
  : row
  {
    : boxed_column
    {
      label = "Kod ciary";
      : text { label = "651A"; }
      : text { label = "651B"; }
      : text { label = "651C"; }
      : text { label = "652A"; }
      : text { label = "652B"; }
      : text { label = "652C"; }
      : text { label = "653A"; }
      : text { label = "653B"; }
      : text { label = "653C"; }
      : text { label = "654A"; }
    }
    : boxed_column
    {
      label = "Popis ciary";
      : text { label = "Tepelne potrubie bez rozlisenia druhu nadzemne"; }
      : text { label = "Tepelne potrubie bez rozlisenia druhu podzemne"; }
      : text { label = "Tepelne potrubie bez rozlisenia druhu podzemne priblizne"; }
      : text { label = "Primarny teplovodny rozvod nadzemny"; }
      : text { label = "Primarny teplovodny rozvod podzemny"; }
      : text { label = "Primarny teplovodny rozvod podzemny priblizny"; }
      : text { label = "Primarny horucovodny rozvod nadzemny"; }
      : text { label = "Primarny horucovodny rozvod podzemny"; }
      : text { label = "Primarny horucovodny rozvod podzemny priblizny"; }
      : text { label = "Primarne tepelne potrubie nadzemne"; }
    }
    : boxed_column
    {
      label = "Kod ciary";
      : text { label = "654B"; }
      : text { label = "654C"; }
      : text { label = "655A"; }
      : text { label = "655B"; }
      : text { label = "655C"; }
      : text { label = ""; }
      : text { label = ""; }
      : text { label = ""; }
      : text { label = ""; }
      : text { label = ""; }
    }
    : boxed_column
    {
      label = "Popis ciary";
      : text { label = "Primarne tepelne potrubie podzemne"; }
      : text { label = "Primarne tepelne potrubie podzemne priblizne"; }
      : text { label = "Sekundarny rozvod teplad nadzemny"; }
      : text { label = "Sekundarny rozvod teplad podzemny"; }
      : text { label = "Sekundarny rozvod teplad podzemny priblizny"; }
      : text { label = ""; }
      : text { label = ""; }
      : text { label = ""; }
      : text { label = ""; }
      : text { label = ""; }
    }
  }

  : button
  {
    key = "zatvoritInfo";
    label = "OK";
    is_default = true;
    is_cancel = true;
    width = 15;
    fixed_width = true;
    alignment = centered;
  }
}

/////// DIALOGOVE OKNO INFO CIARY SILOVEHO VEDENIA ///////

SieteCiarySilovehoVedeniaInfo

: dialog
{
  label = "Informacie o ciarach siloveho vedenia";
  : row
  {
    : boxed_column
    {
      label = "Kod ciary";
      : text { label = "659A"; }
      : text { label = "659B"; }
      : text { label = "659C"; }
      : text { label = "660A"; }
      : text { label = "660B"; }
      : text { label = "660C"; }
      : text { label = "660D"; }
      : text { label = "660E"; }
      : text { label = "661A"; }
      : text { label = "661B"; }
    }
    : boxed_column
    {
      label = "Popis ciary";
      : text { label = "Vonkajsie silove vedenie bez rozlisenia druhu nadzemne"; }
      : text { label = "Vonkajsie silove vedenie bez rozlisenia druhu podzemne"; }
      : text { label = "Vonkajsie silove vedenie bez rozlisenia druhu podzemne priblizne"; }
      : text { label = "Vonkajsie silove vedenie NN nadzemne"; }
      : text { label = "Vonkajsie silove vedenie NN podzemne"; }
      : text { label = "Vonkajsie silove vedenie NN podzemne priblizne"; }
      : text { label = "Vonkajsie silove vedenie NN podzemne PD"; }
      : text { label = "Vonkajsie silove vedenie NN pdozemne VO"; }
      : text { label = "Vonkajsie silove vedenie VN nadzemne"; }
      : text { label = "Vonkajsie silove vedenie VN podzemne"; }
    }
    : boxed_column
    {
      label = "Kod ciary";
      : text { label = "661C"; }
      : text { label = "662A"; }
      : text { label = "662B"; }
      : text { label = "662C"; }
      : text { label = ""; }
      : text { label = ""; }
      : text { label = ""; }
      : text { label = ""; }
      : text { label = ""; }
      : text { label = ""; }
    }
    : boxed_column
    {
      label = "Popis ciary";
      : text { label = "Vonkajsie silove vedenie VN podzemne priblizne"; }
      : text { label = "Vonkajsie silove vedenie VVN nadzemne"; }
      : text { label = "Vonkajsie silove vedenie VVN podzemne"; }
      : text { label = "Vonkajsie silove vedenie VVN podzemne priblizne"; }
      : text { label = ""; }
      : text { label = ""; }
      : text { label = ""; }
      : text { label = ""; }
      : text { label = ""; }
      : text { label = ""; }
    }
  }

  : boxed_row
  {
    label = "Poznamka";
    : text { label = "NN: 50 V - 1000 V | VN: 1000 V - 52 kV | VVN: 52 kV - 300kV"; }
  }

  : button
  {
    key = "zatvoritInfo";
    label = "OK";
    is_default = true;
    is_cancel = true;
    width = 15;
    fixed_width = true;
    alignment = centered;
  }
}

/////// DIALOGOVE OKNO INFO CIARY SLABOPRUDEHO VEDENIA ///////

SieteCiarySlaboprudehoVedeniaInfo

: dialog
{
  label = "Informacie o ciarach slaboprudoveho vedenia";
  : row
  {
    : boxed_column
    {
      label = "Kod ciary";
      : text { label = "663A"; }
      : text { label = "663B"; }
      : text { label = "663C"; }
      : text { label = "664A"; }
      : text { label = "664B"; }
      : text { label = "664C"; }
      : text { label = "670A"; }
      : text { label = "670B"; }
      : text { label = "670C"; }
      : text { label = "670D"; }
    }
    : boxed_column
    {
      label = "Popis ciary";
      : text { label = "Ochranne vedenie zemniace nadzemne"; }
      : text { label = "Ochranne vedenie zemniace podzemne"; }
      : text { label = "Ochranne vedenie zemniace podzemne priblizne"; }
      : text { label = "Kablova stojka nadzemna"; }
      : text { label = "Kablova stojka podzemne"; }
      : text { label = "Kablova stojka podzemna priblizna"; }
      : text { label = "Slaboprudove vedenie spojove nadzemne"; }
      : text { label = "Slaboprudove vedenie spojove podzemne"; }
      : text { label = "Slaboprudove vedenie spojove podzemne priblzine"; }
      : text { label = "Slaboprudove vedenie spojove MR podzemne"; }
    }
    : boxed_column
    {
      label = "Kod ciary";
      : text { label = "670E"; }
      : text { label = "671A"; }
      : text { label = "671B"; }
      : text { label = "671C"; }
      : text { label = "672A"; }
      : text { label = "672B"; }
      : text { label = "672C"; }
      : text { label = "673A"; }
      : text { label = "673B"; }
      : text { label = "673C"; }
    }
    : boxed_column
    {
      label = "Popis ciary";
      : text { label = "Slaboprudove vedenie spojove DK podzemne"; }
      : text { label = "Slaboprudove vedenie poziarnej ochrany nadzemne"; }
      : text { label = "Slaboprudove vedenie poziarnej ochrany podzemne"; }
      : text { label = "Slaboprudove vedenie poziarnej ochrany podzemne priblzine"; }
      : text { label = "Slaboprudove vedenie hodinoveho zariadenia nadzamne"; }
      : text { label = "Slaboprudove vedenie hodinoveho zariadenia podzemne"; }
      : text { label = "Slaboprudove vedenie hodinoveho zariadenia podzemne priblizne"; }
      : text { label = "Vedenie pre antenny rozvod nadzemny"; }
      : text { label = "Vedenie pre antenny rozvod podzemny"; }
      : text { label = "Vedenie pre antenny rozvod  podzemny priblizny"; }
    }
  }

  : button
  {
    key = "zatvoritInfo";
    label = "OK";
    is_default = true;
    is_cancel = true;
    width = 15;
    fixed_width = true;
    alignment = centered;
  }
}

/////// DIALOGOVE OKNO INFO CIARY VODA A VRSTVENICE ///////

SieteCiaryVodaVrstveniceInfo

: dialog
{
  label = "Informacie o ciarach vody a vrstvenic";
  : row
  {
    : boxed_column
    {
      label = "Kod ciary";
      : text { label = "802"; }
      : text { label = "807"; }
      : text { label = "901"; }
      : text { label = "902"; }
      : text { label = "903"; }
      : text { label = "904"; }
      : text { label = "905A"; }
      : text { label = "905B"; }
      : text { label = "906"; }
      : text { label = "909"; }
    }
    : boxed_column
    {
      label = "Popis ciary";
      : text { label = "Vodny tok"; }
      : text { label = "Vodny tok obcasny"; }
      : text { label = "Vrstevnice zakladne"; }
      : text { label = "Vrstevnice zakladne v jednofarebnych mapach"; }
      : text { label = "Vrstevnica zdoraznena"; }
      : text { label = "Vrstevnica zdvoraznena v jednofarebnych mapach"; }
      : text { label = "Vrstevnica doplnkova pre polovicu intervalu"; }
      : text { label = "Vrstevnica doplnkova pre stvrtinu intervalu"; }
      : text { label = "Vrstevnice pomocne"; }
      : text { label = "Terenny stupen uzsi ako 0,5 mm na mape"; }
    }
  }

  : button
  {
    key = "zatvoritInfo";
    label = "OK";
    is_default = true;
    is_cancel = true;
    width = 15;
    fixed_width = true;
    alignment = centered;
  }
}