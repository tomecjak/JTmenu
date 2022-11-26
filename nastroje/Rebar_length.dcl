Rebar_length //nazov dcl

: dialog 
{
  //nazov dialogu
  label = "Vypocet dlzky presahu a kotvenia ocele"; 

  //prvy riadok dialogu
  : boxed_row
  {
    label = "Poznamka";

    //poznamka ohladom vyuzitia vypoctu
    : paragraph
    {
      //prvy riadok textu
      : text_part
      {
        label = "Vypocet sluzi pre rychly vypocet dlzky presahu a kotvenia vystuze.";  
      }
      //druhy riadok textu
      : text_part
      {
        label = "Vypocet plati len pre priame pruty, pre ostatne pripady pouzite nas excel.";  
      }
    } 
  }

  //druhy riadok dialogu
  : boxed_row
  {
    label = "Vstupne hodnoty";

    //stlpec triedy betonu
    : column
    {
      width = 20;
      : text
      {
        label = "Trieda betonu";
      }
      //zoznam s triedou betonu
      : popup_list
      {
        key = "triedaBetonu";
        value = "4";
      }
    }

    //stlpec triedy ocele
    : column
    {
      width = 20;
      : text
      {
        label = "Trieda ocele";
      }
      //zoznam s triedou ocele
      : popup_list
      {
        key = "triedaOcele";
        value = "0";
      }
    }  

    //stlpec priemeru ocele
    : column
    {
      width = 20;
      : text
      {
        label = "Priemer ocele";
      }
      //zoznam s priemerom ocele
      : popup_list
      {
        key = "priemerOcele";
        value = "4";
      }  
    }
  }

  //treti riadok dialogu
  : boxed_row
  {
    label = "Podmienky";

      //stlpec situacie pouzitia
      : column
      {
        width = 20;
        : text
        {
          label = "Navrhove situacie";
        }
        //zoznam s vyberom situacie pouzitia
        : popup_list
        {
          key = "situaciaPouzitia";
          value = "0";
        }
      }

      //stlpec podmienok sudrznosti
      : column
      {
        width = 20;
        : text
        {
          label = "Podmienky sudrznosti";
        }
        //zoznam s vyberom podmienok
        : popup_list
        {
          key = "podmienkySudrznosti";
          value = "0";
        }
      }

      //stlpec percento stykovanej vystuze
      : column
      {
        width = 20;
        : text
        {
          label = "Per. styk. vystuze";
        }
        //zoznam s vyberom podmienok
        : popup_list
        {
          key = "percentoStykovanejVystuze";
          value = "3";
        }
      }      
  }
  
   //stvrty riadok dialogu
  : boxed_row
  {
    label = "Plocha vystuze";

      //stlpec potreba plocha vystuze
      : column
      {
        width = 30;
        //editacne pole pre potrebnu plochu vystuze
        : edit_box
        {
          label = "Potrebna:";
          key = "potrebaPlochaVystuze";
          value = "1.0";
        }
      }

      //stlpec navrhnuta plocha vystuzy
      : column
      {
        width = 30;
        //editacne pole pre navrhnuta plocha vystuze
        : edit_box
        {
          label = "Navrhnuta:";
          key = "navrhnutaPlochaVystuze";
          value = "1.0";
        }
      }

    
  }

   //piati riadok dialogu
  : boxed_row
  {
    label = "Vysledky";

      //stlpec potreba plocha vystuze
      : column
      {
        width = 30;
        : row {
        //text vysledku napisany
        : text
        {
          label = "Kotevna dlzka:";
        }
        //text vysledku pocitany
        : text
        {
          label = "";
          key = "kotevnaDlzka";
        }
        }
      }

      //stlpec navrhnuta plocha vystuzy
      : column
      {
        width = 30;
        : row {
        //text vysledku napisany
        : text
        {
          label = "Dlzka presahu:";
        }
        //text vysledku pocitany
        : text
        {
          label = "";
          key = "dlzkaPresahu";
        }
        }
      }
  }
  
  //posleny riadok dialogu s tlacidlami
  : row
  {
    //tlacidlo vypocitaj
    : button
    {
      key = "vypocitaj";
      label = "Vypocitaj";
      is_default = true;
      mnemonic = "V";
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