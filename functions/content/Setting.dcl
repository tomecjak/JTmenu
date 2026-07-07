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

  : row
  {
    : column
    {
      //prvy riadok dialogu - nastavenie hladiny pre vkladane bloky
      : boxed_radio_column
      {
        label = "Aku hladinu pouzit pre vkladane bloky?";
        //prepinac pre hladinu Prefix_Popis
        : radio_button
        {
          key = "hladinaPrefixPopis";
          label = "Hladina Prefix_Popis";
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
          label = "v hladine Prefix_Popis alebo v hladine 0.";
        }
      }

      //druhy riadok dialogu - nastavenie prexifu hladiny
      : boxed_column
      {
        label = "Aky prefix pouzivat pri vytvorany hladin?";
        //nazov prefixu pre hladiny
        : row {
          : text 
          {  
            label = "Prefix hladiny:";
          }
          : edit_box
          {  
            fixed_width = true;
            key = "layerPrefix";
          }
        }
        //nazov rozdelovaca prefixu a hladiny
        : row {
          : text 
          {  
            label = "Rozdelovac hladiny:";
          }
          : edit_box
          {  
            fixed_width = true;
            key = "layerPrefixSeparator";
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

      //xx riadok dialogu - nastavenie pouzivanie funkci podla JTmenu alebo DPPtools
      : boxed_radio_column
      {
        label = "Pouzivat bloky a funkcie z JTmenu alebo DPPtools?";
        //prepinac pre bloky JTmenu
        : radio_button
        {
          key = "blokyJTmenu";
          label = "JTmenu";
        }
        //prepinac pre bloky DPPtools
        : radio_button
        {
          key = "blokyDPPtools";
          label = "DPPtools";
        }
        //prvy riadok poznamky nastavenia
        : text_part
        { 
          label = "Moznost si nastavit, ci sa maju puzivat bloky,";
        }
        //druhy riadok poznamky nastavenia
        : text_part
        { 
          label = "a funkcie ktore su sucastou JTmenu, alebo";
        }
        //treti riadok poznamky nastavenia
        : text_part
        { 
          label = "ktore su sucastou standardu DPPtools.";
        }
        //stverti riadok poznamky nastavenia
        : text_part
        { 
          label = "Je potrebne mat nainstalovane DPPtools!";
        }
      }

      //xx riadok dialogu - nastavenie pouzivanie nastrojov pre vystuzovania
      : boxed_radio_column
      {
        label = "Aky typ vystuzenia pouzivat?";
        //prepinac pre bloky xxxx
        : radio_button
        {
          key = "rebarLayerType";
          label = "Layer";
        }
        //prepinac pre bloky xxx
        : radio_button
        {
          key = "rebarPolylineType";
          label = "Polyline";
        }
        //prvy riadok poznamky nastavenia
        : text_part
        { 
          label = "Moznost si nastavit, ci nastoje pre pracu,";
        }
        //druhy riadok poznamky nastavenia
        : text_part
        { 
          label = "s vystuzov budu pracovat podla JTmenu hladiny";
        }
        //treti riadok poznamky nastavenia
        : text_part
        { 
          label = "vystuze [JT_Vystuz_30] alebo podla hrubky polyliny.";
        }
      }

      //xx riadok dialogu - dlzka vystuze
      : boxed_radio_column
      {
        label = "Aku dlzku vystuze pouzivat?";  
        //prepinac pre osovu vzdialenost
        : radio_button
        {
          key = "rebarLengthAxis";
          label = "Osova dlzka";
        }
        //prepinac pre vzdielenost povrchu
        : radio_button
        {
          key = "rebarLengthFace";
          label = "Dlzka vonkajsieho povrchu";
        }
        //prvy riadok poznamky nastavenia
        : text_part
        {
          label = "Mosnost si nastavit aku dlzku vystuze pouzivat";
        }
        //druhy riadok poznamky nastavenia
        : text_part
        {
          label = "pri nastroji zapisania dlzky vystuze do popisku.";
        }
        //treti riadok poznamky nastavenia
        : text_part
        {
          label = "Dlzka je pocitana v tvare v akom je polylina!";
        }
      }
    }

    : column
    {
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
        //druhy riadok poznamky nastavenia
        : text_part
        { 
          label = "Toto nastavenie funguje iba v mode JTmenu.";
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
        //prvy riadok poznamky nastavenia
        : text_part
        { 
          label = "Toto nastavenie funguje iba v mode JTmenu.";
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
        //prepinac pre mod annotation
        : radio_button
        {
          key = "modKotyAnnotation";
          label = "Annotation";
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
        //stvrty riadok poznamky nastavenia
        : text_part
        { 
          label = "Toto nastavenie funguje iba pri rezime JTmenu.";
        }
        //piaty riadok poznamky nastavenia
        : text_part
        { 
          label = "V rezime DPPtools je len annotativny mod.";
        }
      }

      //osmi riadok dialogu - verzia JTmenu
      : boxed_row
      {
        label = "Verzia JTmenu";
        : text_part
        { 
          label = "";
          key = "verziaJtMenu";
        }
      }
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
    : text_part { label = "Vsetky ikony pouzite v JTmenu su vygenerovane v Claude Design."; }
    : spacer {}
  }

  //scripty
  : boxed_column
  {
    label = "Scripty"; 
    : text_part { label = "Casti kodu boli pouzite/upravene od autora Lee Mac: www.lee-mac.com"; } 
    : spacer {}
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