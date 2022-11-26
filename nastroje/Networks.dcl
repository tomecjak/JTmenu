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
          label = "Ciary  vody a vrtvenic";
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