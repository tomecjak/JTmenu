Rebar_length //nazov dcl

: dialog 
{
  // nazov dialogu
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

  : boxed_row
  {
    label = "Podmienky";

      //stlpec situacie pouzitia
      : column
      {
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

  //posleny riadok dialogu s tlacidlami
  : row
  {
    //tlacidlo vypocitaj
    : button
    {
      key = "vypocitaj";
      label = "Vypocitaj";
      is_default = true;
    }  

    //tlacidlo cancel
    : button
    {
      key = "cancel";
      label = "Cancel";
      is_cancel = true;
    }  
  }

}