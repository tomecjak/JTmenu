//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -//
// Zone_update.dcl
// (c) Copyright 2025 Tomecko Jakub
//
// Dialog pre funkciu Zone_update.lsp
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -//

Zone_update //nazod dcl

: dialog
{
  //nazov dialogu
  label = "Update ochrannych pasiem";

  //prvy riadok
  : boxed_column
  {
    label = "Ochranne pasma stavieb";
    
    : column
    {
      : text_part
      {
        label = "Poznamka: Ochranne pasma dopravnych ciest podla zakonu c. 35/1984 a 1993/1997, zeleznicnych trati podla zakona c. 513/2009,";
      }
      : text_part
      {
        label = "pohrebisk a krematoria podla zokana c. 470/2005.";
      }
    }

    : spacer {  }
    
    : row {

    //stlpec z nazvom stavby
    : column
    {
      width = 60;
      : text
      {
        label = "Nazov stavby";
      }
      : text
      {
        label = "DIALNICA ALEBO RÝCHLOSTNÁ CESTA";
        key = "nazov_zony_01";
      }
      : text
      {
        label = "CESTA I. TRIEDY";
        key = "nazov_zony_02";
      }
      : text
      {
        label = "CESTA II. TRIEDY";
        key = "nazov_zony_03";
      }
      : text
      {
        label = "CESTA III. TRIEDY";
        key = "nazov_zony_04";
      }
      : text
      {
        label = "MIESTNA KOMUNIKÁCIA";
        key = "nazov_zony_05";
      }
      : text
      {
        label = "ŽELEZNICNÁ DRÁHA";
        key = "nazov_zony_06";
      }
      : text
      {
        label = "OSTATNÉ KOLAJOVÉ A POZEMNÉ LANOVÉ DRÁHY";
        key = "nazov_zony_07";
      }
      : text
      {
        label = "TROLEJBUSOVÁ DRÁHA";
        key = "nazov_zony_08";
      }
      : text
      {
        label = "POHREBISKO";
        key = "nazov_zony_09";
      }
      : text
      {
        label = "KREMATÓRIUM";
        key = "nazov_zony_10";
      }
    }

    //stlpec zo vzdialenostou ochranneho pasma
    : column
    {
      width = 50;
      : text
      {
        label = "Rozsah ochranneho pasma";
      }
      : text
      {
        label = "100 m OD OSU VOZOVKY PRILAHLÉHO JAZDNÉHO PÁSU";
        key = "vzdialenost01";
      }
      : text
      {
        label = "50 m OD OSI VOZOVKY";
        key = "vzdialenost02";
      }
      : text
      {
        label = "25 m OD OSI VOZOVKY";
        key = "vzdialenost03";
      }
      : text
      {
        label = "20 m OD OSI VOZOVKY";
        key = "vzdialenost04";
      }
      : text
      {
        label = "15 m OD OSI VOZOVKY";
        key = "vzdialenost05";
      }
      : text
      {
        label = "60 m OD OSI KRAJNEJ KOLAJE";
        key = "vzdialenost06";
      }
      : text
      {
        label = "15 m OD OSI KRAJNEJ KOLAJE";
        key = "vzdialenost07";
      }
      : text
      {
        label = "10 m OD KRAJNÉHO VODICA TRAKCNÉHO VEDENIA";
        key = "vzdialenost08";
      }
      : text
      {
        label = "50 m OD HRANICE POZEMKU";
        key = "vzdialenost09";
      }
      : text
      {
        label = "100 m OD HRANICE POZEMKU";
        key = "vzdialenost10";
      }
    }

    //stlpec z oznacenim riadka
    : column
    {
      : text
      {
        label = "";
      }
      : toggle
      {
        key = "oznacit01";
        label = "Zapisat";
      }
      : toggle
      {
        key = "oznacit02";
        label = "Zapisat";
      }
      : toggle
      {
        key = "oznacit03";
        label = "Zapisat";
      }
      : toggle
      {
        key = "oznacit04";
        label = "Zapisat";
      }
      : toggle
      {
        key = "oznacit05";
        label = "Zapisat";
      }
      : toggle
      {
        key = "oznacit06";
        label = "Zapisat";
      }
      : toggle
      {
        key = "oznacit07";
        label = "Zapisat";
      }
      : toggle
      {
        key = "oznacit08";
        label = "Zapisat";
      }
      : toggle
      {
        key = "oznacit09";
        label = "Zapisat";
      }
      : toggle
      {
        key = "oznacit10";
        label = "Zapisat";
      }
    }
    }
  }

  //druhy riadok
  : boxed_column
  {
    label = "Ochranne pasma sieti";

    : column
    {
      : text_part
      {
        label = "Poznamka: Ochranne pasma verejneho vodovodu a kanalizacie podla zakona c. 442/2002 a 276/2001, vonkajsieho nadzemneho";
      }
      : text_part
      {
        label = "a podzemneho elektrickeho vedenia podla zakona c. 656/2004, plynarenskych zariadeni podla zakona c. 656/2004.";
      }
    }

    : spacer {  }
    
    : row
    {
    
    //stlpec z nazvom siete
    : column
    {
      width = 60;
      : text
      {
        label = "Nazov siete";
      }
      : text
      {
        label = "VEREJNÝ VODOVOD A KANALIZÁCIA DO PRIEMERU 500 mm";
        key = "nazov_zony_11";
      }
      : text
      {
        label = "VEREJNÝ VODOVOD A KANALIZÁCIA NAD PRIEMER 500 mm";
        key = "nazov_zony_12";
      }
      : text
      {
        label = "NADZEMNÉ ELEKTRICKÉ VEDENIE OD 1 kV DO 35 kV";
        key = "nazov_zony_13";
      }
      : text
      {
        label = "NADZEMNÉ ELEKTRICKÉ VEDENIE OD 1 kV DO 35 kV";
        key = "nazov_zony_14";
      }
      : text
      {
        label = "NADZEMNÉ ELEKTRICKÉ VEDENIE OD 1 kV DO 35 kV";
        key = "nazov_zony_15";
      }
      : text
      {
        label = "NADZEMNÉ ELEKTRICKÉ VEDENIE OD 35 kV DO 110 kV";
        key = "nazov_zony_16";
      }
      : text
      {
        label = "NADZEMNÉ ELEKTRICKÉ VEDENIE OD 110 kV DO 220 kV";
        key = "nazov_zony_17";
      }
      : text
      {
        label = "NADZEMNÉ ELEKTRICKÉ VEDENIE OD 220 kV DO 400 kV";
        key = "nazov_zony_18";
      }
      : text
      {
        label = "NADZEMNÉ ELEKTRICKÉ VEDENIE NAD 400 kV";
        key = "nazov_zony_19";
      }
      : text
      {
        label = "PODZEMNÉ ELEKTRICKÉ VEDENIE DO 110 kv";
        key = "nazov_zony_20";
      }
      : text
      {
        label = "PODZEMNÉ ELEKTRICKÉ VEDENIE NAD 110 kv";
        key = "nazov_zony_21";
      }
      : text
      {
        label = "PLYNOVOD S PREVÁDZKOVÝM TLAKOM NIŽŠÍM AKO 0,4 MPa";
        key = "nazov_zony_22";
      }
      : text
      {
        label = "PLYNOVOD S MENOVITOU SVETLOSTOU DO 200 mm";
        key = "nazov_zony_23";
      }
      : text
      {
        label = "PLYNOVOD S MENOVITOU SVETLOSTOU OD 201 mm DO 500 mm";
        key = "nazov_zony_24";
      }
      : text
      {
        label = "PLYNOVOD S MENOVITOU SVETLOSTOU OD 501 mm DO 700 mm";
        key = "nazov_zony_25";
      }
      : text
      {
        label = "PLYNOVOD S MENOVITOU SVETLOSTOU NAD 700 mm";
        key = "nazov_zony_26";
      }
    }

    //stlpec zo vzdialenostou ochranneho pasma
    : column
    {
      width = 50;
      : text
      {
        label = "Rozsah ochranneho pasma";
      }
      : text
      {
        label = "1,5 m OD OSI";
        key = "vzdialenost11";
      }
      : text
      {
        label = "3,0 m OD OSI";
        key = "vzdialenost12";
      }
      : text
      {
        label = "10 m OD KRAJNÉHO VODICA BEZ IZOLÁCIE";
        key = "vzdialenost13";
      }
      : text
      {
        label = "4 m OD KRAJNÉHO VODICA SO ZÁKLADNOU IZOLÁCIOU";
        key = "vzdialenost14";
      }
      : text
      {
        label = "1 m PRE ZAVESENÉ KÁBLOVÉ VEDENIUE";
        key = "vzdialenost15";
      }
      : text
      {
        label = "15 m OD KRAJNÉHO VODICA";
        key = "vzdialenost16";
      }
      : text
      {
        label = "20 m OD KRAJNÉHO VODICA";
        key = "vzdialenost17";
      }
      : text
      {
        label = "25 m OD KRAJNÉHO VODICA";
        key = "vzdialenost18";
      }
      : text
      {
        label = "35 m OD KRAJNÉHO VODICA";
        key = "vzdialenost19";
      }
      : text
      {
        label = "1 m OD KRAJNÉHO VODICA";
        key = "vzdialenost20";
      }
      : text
      {
        label = "3 m OD KRAJNÉHO VODICA";
        key = "vzdialenost21";
      }
      : text
      {
        label = "1 m OD OSI PLYNOVODU";
        key = "vzdialenost22";
      }
      : text
      {
        label = "4 m OD OSI PLYNOVODU";
        key = "vzdialenost23";
      }
      : text
      {
        label = "8 m OD OSI PLYNOVODU";
        key = "vzdialenost24";
      }
      : text
      {
        label = "12 m OD OSI PLYNOVODU";
        key = "vzdialenost25";
      }
      : text
      {
        label = "50 m OD OSI PLYNOVODU";
        key = "vzdialenost11''26";
      }
    }

    //stlpec z oznacenim riadka
    : column
    {
      : text
      {
        label = "";
      }
      : toggle
      {
        key = "oznacit11";
        label = "Zapisat";
      }
      : toggle
      {
        key = "oznacit12";
        label = "Zapisat";
      }
      : toggle
      {
        key = "oznacit13";
        label = "Zapisat";
      }
      : toggle
      {
        key = "oznacit14";
        label = "Zapisat";
      }
      : toggle
      {
        key = "oznacit15";
        label = "Zapisat";
      }
      : toggle
      {
        key = "oznacit16";
        label = "Zapisat";
      }
      : toggle
      {
        key = "oznacit17";
        label = "Zapisat";
      }
      : toggle
      {
        key = "oznacit18";
        label = "Zapisat";
      }
      : toggle
      {
        key = "oznacit19";
        label = "Zapisat";
      }
      : toggle
      {
        key = "oznacit20";
        label = "Zapisat";
      }
      : toggle
      {
        key = "oznacit21";
        label = "Zapisat";
      }
      : toggle
      {
        key = "oznacit22";
        label = "Zapisat";
      }
      : toggle
      {
        key = "oznacit23";
        label = "Zapisat";
      }
      : toggle
      {
        key = "oznacit24";
        label = "Zapisat";
      }
      : toggle
      {
        key = "oznacit25";
        label = "Zapisat";
      }
      : toggle
      {
        key = "oznacit26";
        label = "Zapisat";
      }
    }
  }  

  //posledny riadok
  : row
  {
    //tlacidlo aktualizovat
    : button
    {
      label = "Aktualizovat";
      key = "aktualizovat";
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
}