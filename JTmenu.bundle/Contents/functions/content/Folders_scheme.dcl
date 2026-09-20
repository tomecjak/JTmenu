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
  label = "Vytvorenie struktury dokumentacie";

  //definovanie stlpca
  : boxed_radio_column

  {
    label = "Stupen dokumentacia";  

    //prvy riadok - studia uskutocnitelnosti (str 50)
    : radio_button
    {
      key = "studiaUskutocnitelnosti";
      label = "Studia uskutocnitelnosti (STU) - SK";
    }

    //druhy riadok - dokumentacia stavebneho zameru (str 66)
    : radio_button
    {
      key = "dokumentaciaStavebnehoZameru";
      label = "Dokumentacia stavebneho zameru (DSZ) - SK";
    }

    //treti riadok - dokumentacia pre uzemne rozhodnutie (str 76)
    : radio_button
    {
      key = "dokumentaciaPreUzemneRozhodnutie";
      label = "Dokumentacia pre uzemne rozhodnutie (DUR) - SK";
    }

    //stvrty riadok - dokumentacia na stavebne povolenie (str 104)
    : radio_button
    {
      key = "dokumentaciaNaStavebnePovolenie";
      label = "Dokumentacia na stavebne povolenie (DSP) - SK";
    }

    //piaty riadok - dokumentacia na ohlasenie stavby (str 165)
    : radio_button
    {
      key = "dokumentaciaNaOhlasenieStavby";
      label = "Dokumentacia na ohlasenie stavby (DOS) - SK";
    }

    //siesty riadok - dokumentacia na uzemne rozhodnutie a stavebne povolenie (str 184)
    : radio_button
    {
      key = "dokumentaciaNaUzemneRozhodnutieStavebnePovenie";
      label = "Dokumentacia na uzemne rozhodnutie a stavebne povolenie (DURSP) - SK";
    }

    //siedmi riadok - dokumentacia na realizaciu stavby (str 225)
    : radio_button
    {
      key = "dokumentaciaNaRealizaciuStavby";
      label = "Dokumentacia na realizaciu stavby (DRS) - SK";
    }

    //osmi riadok - dokumentacia na stavebne povolenie a realizaciu stavby (str 280)
    : radio_button
    {
      key = "dokumentaciaNaStavebnePovolenieRealizaciuStavby";
      label = "Dokumentacia na stavebne povolenie a realizaciu stavby (DSPRS) - SK";
    }

    //deviaty riadok - dokumentacia na vykonanie prac (str 332)
    : radio_button
    {
      key = "dokumentaciaNaVykonanieprac";
      label = "Dokumentacia na vykonanie prac (DVP) - SK";
    }

    //desiaty riadok - dokumentacie skutocneho realizovania stavby (str 336)
    : radio_button
    {
      key = "dokumentaciaSkutocnehoRealizovaniaStavby";
      label = "Dokumentacia skutocneho realizovania stavby (DSRS) - SK";
    }

    //jedenasty riadok (I) - vyhkedavaci studie (str 23)
    : radio_button
    {
      key = "vyhledavaciStudie_CZ";
      label = "Vyhledavaci studie (VST) - CZ";
    }

    //jedenasty riadok (II) - technicka studie (str 30)
    : radio_button
    {
      key = "technickaStudie_CZ";
      label = "Technicka studie (TST) - CZ";
    }

    //dvanasty riadok - dokumentace pro vydani uzemniho rozhodnuti (str 43)
    : radio_button
    {
      key = "dokumentaceProVydaniUzemnihoRozhodnuti_CZ";
      label = "Dokumentace pre vydani uzemnniho rozhodnuti (DUR) - CZ";
    }

    //trinasty riadok - dokumenrace pro vydani spolecneho povoleni (str 64)
    : radio_button
    {
      key = "dokumentaceProVydaniSpolocnehoPovoleni_CZ";
      label = "Dokumentace pro vydani spolocneho povoleni (DUSP) - CZ";
    }

    //strnasty riadok - dokumenrace pro vydani spolecneho povoleni u staveb dopravni infrastruktury (str 85)
    : radio_button
    {
      key = "dokumentaceProVydaniSpolocnehoPovoleniUStavebDopravniInfrastruktury_CZ";
      label = "Dokumentace pro vydani spolocneho povoleni u staveb dopravni infrastruktury (DUSP-DI) - CZ";
    }

    //patnasty riadok - projektova dokumentace pro vydani stavebneho povoleni (str 107)
    : radio_button
    {
      key = "projektovaDokumentaceProVydaniStavebnihoPovoleni_CZ";
      label = "Projektova dokumentace pro vydani stavebniho povoleni (DSP) - CZ";
    }

    //sestnasty riadok - projektova dokumentace pro provadeni stavby (str 128)
    : radio_button
    {
      key = "projektovaDokumentaceProProvadeniStavby_CZ";
      label = "Projektova dokumentace pro provadeni stavby (PDPS) - CZ";
    }

    //sedemnasty riadok - vybrane dokumenty zadavaci dokumentace stavby (str 128)
    : radio_button
    {
      key = "vybraneDokumentyZadavaciDokumentaceStavby_CZ";
      label = "Vybrane dokumenty zadvaci dokumentace stavby (VD-ZDS) - CZ";
    }

    //osemnasty riadok - dokumentace bouracich praci (str 141)
    : radio_button
    {
      key = "dokumentaceBouracichPraci_CZ";
      label = "Dokumentace bouracich praci (DBP) - CZ";
    }

    //devednasty riadok - realizacni dokumentace stavby (str 144)
    : radio_button
    {
      key = "realizacniDokumentaceStavby_CZ";
      label = "Realizacni dokumentace stavby (RDS) - CZ";
    }

    //dvaciaty riadok - dokumentace skutocneho provedeni stavby (str 146)
    : radio_button
    {
      key = "dokumentaceSkutocnehoProvedeniStavby_CZ";
      label = "Dokumentace skutecneho provedeni stavby (DSPS) - CZ";
    }

    //posledny riadok - vlastna struktura
    : radio_button
    {
      key = "vlastnaStruktura";
      label = "Vlastna struktura";
    }

  }  

  //predposledny box - Informacie o strukture dokumentacie
  : boxed_column
  {
    label = "Informacie";
    : text{ label = "Struktura dokumentacia sa vytvara podla TP 019 - Dokumentacia stavieb ciest (SK)"; }
    : text{ label = "a Smernice pro dokumentaci staveb pozemnich komunikaci (CZ)."; }
    : text{ label = "Pre vytvorenie vlastnej struktury je potrebne vytvorit subor .txt v ktorom bude kazda cesta v novom"; }
    : text{ label = "riadku v formate: \\\\Folder1; \\\\Folder1\\\\Folder2; alebo pouzite tlacidlo Sablona."; }
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
      mnemonic = "V";
    } 

    //tlacidlo sablona
    : button
    {
      key = "sablona";
      label = "Sablona";
      is_default = true;
      mnemonic = "S";
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