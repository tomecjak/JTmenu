//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -//
// Folders_scheme.dcl
// (c) Copyright 2023 Tomecko Jakub
//
// Dialog pre funkciu Folders_scheme.lsp 
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -//

Folders_scheme //nazov dcl

: dialog
{
  //nazov dialogu
  label = "Vytvorenie struktury";

  //definovanie stlpca
  : boxed_radio_column
  {
    label = "Stupen dokumentacia";  

    //prvy riadok - studia uskutocnitelnosti (str 50)
    : radio_button
    {
      key = "studiaUskutocnitelnosti";
      label = "Studia uskutocnitelnosti (STU)";
    }

    //druhy riadok - dokumentacia stavebneho zameru (str 66)
    : radio_button
    {
      key = "dokumentaciaStavebnehoZameru";
      label = "Dokumentacia stavebneho zameru (DSZ)";
    }
,
    //treti riadok - dokumentacia pre uzemne rozhodnutie (str 76)
    : radio_button
    {
      key = "dokumentaciaPreUzemneRozhodnutie";
      label = "Dokumentacia pre uzemne rozhodnutie (DUR)";
    }

    //stvrty riadok - dokumentacia na stavebne povolenie (str 104)
    : radio_button
    {
      key = "dokumentaciaNaStavebnePovolenie";
      label = "Dokumentacia na stavebne povolenie (DSP)";
    }

    //piaty riadok - dokumentacia na ohlasenie stavby (str 165)
    : radio_button
    {
      key = "dokumentaciaNaOhlasenieStavby";
      label = "Dokumentacia na ohlasenie stavby (DOS)";
    }

    //siesty riadok - dokumentacia na uzemne rozhodnutie a stavebne povolenie (str 184)
    : radio_button
    {
      key = "dokumentaciaNaUzemneRozhodnutieStavebnePovenie";
      label = "Dokumentacia na uzemne rozhodnutie a stavebne povolenie (DURSP)";
    }

    //siedmi riadok - dokumentacia na realizaciu stavby (str 225)
    : radio_button
    {
      key = "dokumentaciaNaRealizaciuStavby";
      label = "Dokumentacia na realizaciu stavby (DRS)";
    }

    //posledny riadok - vlastna struktura
    : radio_button
    {
      key = "vlastnaStruktura";
      label = "Vlastna struktura";
    }

  }  

  //posledny riadok dialogu s tlacidlami
  : row
  {
    //tlacidlo ulozit
    : button
    {
      key = "vytvorit";
      label = "Vytvorit";
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