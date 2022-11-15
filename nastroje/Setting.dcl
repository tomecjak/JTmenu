Setting //nazov dcl

: dialog
{
  //nazov dialogu
  label ="Nastavenia";

  //prvy riadok dialogu - nastavenie hladiny pre vkladane bloky
  : boxed_radio_column
  {
    label = "Aku hladinu pouzit pre vkladane bloky?";
    //prepinac pre hladinu DP_Popis
    : radio_button
    {
      key = "hladinaDpPopis";
      label = "Hladina DP_Popis";
    }
    //prepinac pre hlaidnu 0
    : radio_button
    {
      key = "hladinaNula";
      label = "Hladina 0";
    }
    //prvy riadok poznamky nastavenia
    : text_part
    { 
      label = "Tymto nastavenim urcite ci vkladane bloky";
    }
    //druhy riadok poznamky nastavenia
    : text_part
    { 
      label = "budu v hladine DP_Popis alebo v haldine 0.";
    }
  }

  //druhy riadok dialogu - nastavenie DIMSCALE pre vkladane bloky
  : boxed_radio_column
  {
    label = "V akom mode pouzivat bloky a koty?";
    //prepinac pre mod klasicky
    : radio_button
    {
      key = "modKlasicky";
      label = "Kladicky";
    }
    //prepinac pre mod dimscale
    : radio_button
    {
      key = "modDimscale";
      label = "Dimscale";
    }
    //prvy riadok poznamky nastavenia
    : text_part
    { 
      label = "Pri nastaveny modu klasicky sa vkladaju";
    }
    //druhy riadok poznamky nastavenia
    : text_part
    { 
      label = "bloky v mierke 1:50. V mode dimscale sa";
    }
    //treti riadok poznamky nastavenia
    : text_part
    { 
      label = "bloky vkladaju podla mierky kot (dimscale).";
    }
  }

  //treti riadok dialogu - verzia JTmenu
  : boxed_row
  {
    label = "Verzia JTmenu";
    : text
    { 
      label = "";
      key = "verziaJtMenu";
    }
  }

  //posledny riadok dialogu s tlacidlami
  : row
  {
    //tlacidlo ulozit
    : button
    {
      key = "ulozit";
      label = "Ulozit";
      is_default = true;
    }  

    //tlacidlo zavriet
    : button
    {
      key = "cancel";
      label = "Zavriet";
      is_cancel = true;
    }
  }
}