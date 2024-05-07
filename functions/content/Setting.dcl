//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -//
// Setting.dcl
// (c) Copyright 2023 Tomecko Jakub
//
// Dialog pre funkciu Setting.lsp 
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -//

Setting //nazov dcl

: dialog
{
  //nazov dialogu
  label ="Nastavenia";

  //prvy riadok dialogu - nastavenie hladiny pre vkladane bloky
  : boxed_radio_column
  {
    label = "Aku hladinu pouzit pre vkladane bloky?";
    //prepinac pre hladinu Prefix_Popis
    : radio_button
    {
      key = "hladinaPrefixPopis";
      label = "Hladina XX_Popis";
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
      label = "budu v hladine XX_Popis alebo v hladine 0.";
    }
  }

  //druhy riadok dialogu - nastavenie prexifu hladiny
  : boxed_column
  {
    label = "Aky prefix pouzivat pri vytvorany hladin?";
    //nazov prefixu pre klasicke hladiny
    : row {
      : text 
      {  
        label = "Klasicke hladiny:";
      }
      : edit_box
      {  
        fixed_width = true;
        key = "layerPrefix";
      }
    }
    //nazov prefixu pre hladiny noveho stavu
    : row {
      : text 
      {  
        label = "Hladiny noveho stavu:";
      }
      : edit_box
      {  
        fixed_width = true;
        key = "layerPrefixNew";
      }
    }
    //prvy riadok poznamky nastavenia
    : text_part
    { 
      label = "Moznost si nastavit prexif pred nazvom hladiny,";
    }
    //druhy riadok poznamky nastavenia
    : text_part
    { 
      label = "pri vytvarany novych hladin.";
    }
  }

  //treti riadok dialogu - nastavenie DIMSCALE pre vkladane bloky
  : boxed_radio_column
  {
    label = "V akom mode pouzivat bloky?";
    //prepinac pre mod klasicky
    : radio_button
    {
      key = "modKlasicky";
      label = "Klasicky";
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
      label = "bloky v mierke 1:X. V mode dimscale sa";
    }
    //treti riadok poznamky nastavenia
    : text_part
    { 
      label = "bloky vkladaju podla mierky kot (DIMSCALE).";
    }
  }

  //stvrty riadok dialogu - nastavenie mierky vkladanych blokov
  : boxed_column
  {
    label = "Aku mierku pouzit pre vkladane bloky:";
    //nazov prefixu pre klasicke hladiny
    : row {
      : text 
      {  
        label = "Miekra blokov:";
      }
      : edit_box
      {  
        fixed_width = true;
        key = "blocksScale";
      }
    }
    //prvy riadok poznamky nastavenia
    : text_part
    { 
      label = "Moznost si nastavit mierku vkladanych blokov.";
    }
  }

  //piaty riadok dialogu - nastavenie jazyku blokov
  : boxed_radio_column
  {
    label = "V akom jazyku maju byt vkladane bloky?";
    //prepinac pre slovensky jazyk
    : radio_button
    {
      key = "blocksLanguageSK";
      label = "Slovensky";
    }
    //prepinac pre cesky jazyk
    : radio_button
    {
      key = "blocksLanguageCZ";
      label = "Cesky";
    }
    //prepinac pre anglicky jazyk
    : radio_button
    {
      key = "blocksLanguageEN";
      label = "Anglicky";
    }
  }

  //siesty riadok dialogu - nastavenie generovanych kot
  : boxed_radio_column
  {
    label = "V akom mode vygenerovat koty?";
    //prepinac pre mod klasicky
    : radio_button
    {
      key = "modKotyKlasicky";
      label = "Klasicky";
    }
    //prepinac pre mod dimscale
    : radio_button
    {
      key = "modKotyDimscale";
      label = "Dimscale";
    }
    //prvy riadok poznamky nastavenia
    : text_part
    { 
      label = "Pri nastaveny modu klasicky sa koty";
    }
    //druhy riadok poznamky nastavenia
    : text_part
    { 
      label = "generaju samostatne pre vsetky mierky.";
    }
    //treti riadok poznamky nastavenia
    : text_part
    { 
      label = "Pri nastaveny modu dimscale sa vygeneraje,";
    }
    //stvrty riadok poznamky nastavenia
    : text_part
    { 
      label = "len jedna kota, ktorej velkost je";
    }
    //piaty riadok poznamky nastavenia
    : text_part
    { 
      label = "riadena hodnotou DIMSCALE.";
    }
  }

  //siesty riadok dialogu - verzia JTmenu
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
      label = "Ulozit";
      key = "ulozit";
      is_default = true;
      mnemonic = "U";
    }  

    //tlacidlo zavriet
    : button
    {
      label = "Zavriet";
      key = "cancel";
      is_cancel = true;
      mnemonic = "Z";
    }
  }
}