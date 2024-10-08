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
      label = "Tymto nastavenim urcite ci vkladane bloky budu";
    }
    //druhy riadok poznamky nastavenia
    : text_part
    { 
      label = "v hladine XX_Popis alebo v hladine 0.";
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
      label = "Pri nastaveny modu klasicky sa vkladaju bloky";
    }
    //druhy riadok poznamky nastavenia
    : text_part
    { 
      label = "v mierke 1:X. V mode dimscale sa bloky";
    }
    //treti riadok poznamky nastavenia
    : text_part
    { 
      label = "vkladaju podla mierky kot (DIMSCALE).";
    }
  }

  //stvrty riadok dialogu - nastavenie mierky vkladanych blokov
  : boxed_column
  {
    label = "Mierka pre vkladane bloky:";
    //nazov prefixu pre klasicke hladiny
    : row {
      : text 
      {  
        label = "Mierka bloku 1:";
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

  //piaty riadok dialogu - nastavenie mierky vkladanych blokov dopravneho znacenia
  : boxed_column
  {
    label = "Mierka pre vkladane bloky dopravneho znacenia:";
    //nazov prefixu pre klasicke hladiny
    : row {
      : text 
      {  
        label = "Mierka bloku 1:";
      }
      : edit_box
      {  
        fixed_width = true;
        key = "signBlocksScale";
      }
    }
    //prvy riadok poznamky nastavenia
    : text_part
    { 
      label = "Moznost si nastavit mierku vkladanych blokov";
    }
    : text_part
    { 
      label = "dopravneho znacenia.";
    }
  }

  //siesty riadok dialogu - nastavenie jazyku blokov
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

  //siedmi riadok dialogu - nastavenie generovanych kot
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
      label = "Pri nastaveny modu klasicky sa koty genereju";
    }
    //druhy riadok poznamky nastavenia
    : text_part
    { 
      label = "samostatne pre vsetky mierky. Pri nastaveny";
    }
    //treti riadok poznamky nastavenia
    : text_part
    { 
      label = "modu dimscale sa vygeneraje, len jedna kota,";
    }
    //stvrty riadok poznamky nastavenia
    : text_part
    { 
      label = "ktorej velkost je riadena hodnotou DIMSCALE.";
    }
  }

  //osmi riadok dialogu - verzia JTmenu
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

    //tlacidlo about
    : button
    {
      label = "About";
      key = "about";
      is_default = true;
      mnemonic = "A";
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

/////// DIALOGOVE OKNO ABOUT ///////

About

: dialog
{
  label = "About";
  //ikony
  : boxed_column
  {
    label = "Ikony";
    : text_part { label = "Vsetky ikony pouzite v JTmenu su pouzite zo stanky: www.flaticon.com."; }
    : spacer {}
    : text_part { label = "Zoznanam autorov od ktorych boli pouzite ikony: Freepik, Suraiya Mili,"; }
    : text_part { label = "Riajulislam, Smashicons, Graphiverse, Soodesign, Juicy_fish, Zafdesign,"; }
    : text_part { label = "Meaicon, Laisa Islam Ani, Vector Market, IconixarPro, Creatype, Gulraiz,"; }
    : text_part { label = "Bukeicon, DinosoftLabs, Elzicon, Elastic1, JC Icon, Kerismaker, Vectorsclub,"; }
    : text_part { label = "Pixel perfec."; }
  }

  //scripty
  : boxed_column
  {
    label = "Scripty"; 
    : text_part { label = "Casti kodu boli pouzite/upravene od autora Lee Mac: www.lee-mac.com"; } 
  }

  : button
  {
    key = "zatvoritAbout";
    label = "OK";
    is_default = true;
    is_cancel = true;
    width = 15;
    fixed_width = true;
    alignment = centered;
  }
}