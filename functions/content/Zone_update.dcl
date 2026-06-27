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

  //prvy riadok - cestne ochranne pasma
  : boxed_column
  {
    label = "Cestne ochranne pasma";
    
    : column
    {
      : text_part
      {
        label = "Sluzia na ochranu dialnic, ciest a miestnych komunikacii mimo uzemia zastaveneho, alebo urceneho na suvisle zastavenia.";
      }
      : text_part
      {
        label = "Pre jednotlive druhy komunikacii urcuje sirku ochrannych pasiem Vyhlaska c. 35/1984 Zb.";
      }
      : text_part
      {
        label = "Poznamka: Na smerovo rozdelenych cestach sa vzdialenosti meraju od osi prilahlej vozovky.";
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
        label = "Nazov";
      }
      : text
      {
        label = "Dialnica";
        key = "nazov_zony_01";
      }
      : text
      {
        label = "Cesta I. triedy";
        key = "nazov_zony_02";
      }
      : text
      {
        label = "Cesta II. triedy";
        key = "nazov_zony_03";
      }
      : text
      {
        label = "Cesta III. triedy";
        key = "nazov_zony_04";
      }
      : text
      {
        label = "Miestna komunikacia";
        key = "nazov_zony_05";
      }
    }

    //stlpec zo vzdialenostou ochranneho pasma
    : column
    {
      width = 50;
      : text
      {
        label = "Ochranne pasmo";
      }
      : text
      {
        label = "100 m od osi vozovky";
        key = "vzdialenost01";
      }
      : text
      {
        label = "50 m od osi vozovky";
        key = "vzdialenost02";
      }
      : text
      {
        label = "25 m od osi vozovky";
        key = "vzdialenost03";
      }
      : text
      {
        label = "20 m od osi vozovky";
        key = "vzdialenost04";
      }
      : text
      {
        label = "15 m od osi vozovky";
        key = "vzdialenost05";
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
    }
    }
  }

  //druhy riadok - zeleznicne ochranne pasma
  : boxed_column
  {
    label = "Zeleznicne ochranne pasma";
    
    : column
    {
      : text_part
      {
        label = "Sluzia na ochranu drahy a na ochranu prevadzky na drahe v zmysle Zakona o drahach c. 513/2009 Z. z.";
      }
      : text_part
      {
        label = "Su vymedzene pristorom po obidvoch stranach drahy.";
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
        label = "Nazov";
      }
      : text
      {
        label = "Zeleznicna draha";
        key = "nazov_zony_06";
      }
      : text
      {
        label = "Ostatne kolajove drahy";
        key = "nazov_zony_07";
      }
      : text
      {
        label = "Pozemna lanova draha";
        key = "nazov_zony_08";
      }
      : text
      {
        label = "Visuta lanova draha";
        key = "nazov_zony_09";
      }
      : text
      {
        label = "Trolejbusova draha";
        key = "nazov_zony_10";
      }
    }

    //stlpec zo vzdialenostou ochranneho pasma
    : column
    {
      width = 50;
      : text
      {
        label = "Ochranne pasmo";
      }
      : text
      {
        label = "60 m od osi krajnej kolaje";
        key = "vzdialenost06";
      }
      : text
      {
        label = "15 m od osi krajnej kolaje";
        key = "vzdialenost07";
      }
      : text
      {
        label = "15 m od osi krajnej kolaje";
        key = "vzdialenost08";
      }
      : text
      {
        label = "15 m od nosneho alebo dopravneho lana";
        key = "vzdialenost09";
      }
      : text
      {
        label = "10 m od krajneho vodica trakcneho vedenia";
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

  //treti riadok - ochranne pasma vodohospodarskych vedeni a zariadeni
  : boxed_column
  {
    label = "Ochranne pasma vodohospodarskych vedeni a zariadeni";
    
    : column
    {
      : text_part
      {
        label = "Na ochranu verejnych vodovodov a verejnych kanalizacii sa vymedzuje podla Zakona c. 442/2002 Z. z.";
      }
      : text_part
      {
        label = "o verejnych vodovodoch a verejnych kanalizaciach.";
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
        label = "Nazov";
      }
      : text
      {
        label = "Verejny vodovod do DN500";
        key = "nazov_zony_11";
      }
      : text
      {
        label = "Verejny kanalizaci do DN500";
        key = "nazov_zony_12";
      }
      : text
      {
        label = "Verejny vodovod nad DN500";
        key = "nazov_zony_13";
      }
      : text
      {
        label = "Verejny kanalizaci nad DN500";
        key = "nazov_zony_14";
      }
    }

    //stlpec zo vzdialenostou ochranneho pasma
    : column
    {
      width = 50;
      : text
      {
        label = "Ochranne pasmo";
      }
      : text
      {
        label = "1,8 m od vonkajsieho obrysu";
        key = "vzdialenost11";
      }
      : text
      {
        label = "1,8 m od vonkajsieho obrysu";
        key = "vzdialenost12";
      }
      : text
      {
        label = "2,5 m od vonkajsieho obrysu";
        key = "vzdialenost13";
      }
      : text
      {
        label = "2,5 m od vonkajsieho obrysu";
        key = "vzdialenost14";
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
    }
    }
  }

  //stvrty riadok - ochranne pasma elektroenergetickych zariadeni
  : boxed_column
  {
    label = "Ochranne pasma elektroenergetickych zariadeni";
    
    : column
    {
      : text_part
      {
        label = "Ochrana elektroenergetickych zariadeni sa vymedzuje podla Zakona c. 656/2004 Z. z. o energetike.";
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
        label = "Nazov";
      }
      : text
      {
        label = "Vonkajsie elektricke vedenie od 1 kV do 35 kV";
        key = "nazov_zony_15";
      }
      : text
      {
        label = "Vonkajsie elektricke vedenie od 35 kV do 110 kV";
        key = "nazov_zony_16";
      }
      : text
      {
        label = "Vonkajsie elektricke vedenie od 110 kV do 220 kV";
        key = "nazov_zony_17";
      }
      : text
      {
        label = "Vonkajsie elektricke vedenie od 220 kV do 400 kV";
        key = "nazov_zony_18";
      }
      : text
      {
        label = "Vonkajsie elektricke vedenie nad 400 kV";
        key = "nazov_zony_19";
      }
      : text
      {
        label = "Zavesene kablove vedenie od 1 kv do 110 kV";
        key = "nazov_zony_20";
      }
      : text
      {
        label = "Podzemne elektricke vedenie do 110 kv";
        key = "nazov_zony_21";
      }
      : text
      {
        label = "Podzemne elektricke vedenie nad 110 kv";
        key = "nazov_zony_22";
      }
      : text
      {
        label = "Elektricka stanica";
        key = "nazov_zony_23";
      }
      : text
      {
        label = "Transfostanica z vysokeho na nizke napatie";
        key = "nazov_zony_24";
      }
    }

    //stlpec zo vzdialenostou ochranneho pasma
    : column
    {
      width = 50;
      : text
      {
        label = "Ochranne pasmo";
      }
      : text
      {
        label = "10 m od krajneho vodica";
        key = "vzdialenost15";
      }
      : text
      {
        label = "15 m od krajneho vodica";
        key = "vzdialenost16";
      }
      : text
      {
        label = "20 m od krajneho vodica";
        key = "vzdialenost17";
      }
      : text
      {
        label = "25 m od krajneho vodica";
        key = "vzdialenost18";
      }
      : text
      {
        label = "35 m od krajneho vodica";
        key = "vzdialenost19";
      }
      : text
      {
        label = "2 m od krajneho vodica";
        key = "vzdialenost20";
      }
      : text
      {
        label = "1 m od krajneho kabla";
        key = "vzdialenost21";
      }
      : text
      {
        label = "3 m od krajneho kabla";
        key = "vzdialenost22";
      }
      : text
      {
        label = "30 m od oplotenia";
        key = "vzdialenost23";
      }
      : text
      {
        label = "10 m od konstrukcie stanice";
        key = "vzdialenost24";
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
    }
    }
  }









  //XX riadok - zeleznicne ochranne pasma
  : boxed_column
  {
    label = "XXX";
    
    : column
    {
      : text_part
      {
        label = "Sluzia na ochranu dialnic, ciest a miestnych komunikacii mimo uzemia zastaveneho, alebo urceneho na suvisle zastavenia.";
      }
      : text_part
      {
        label = "Pre jednotlive druhy komunikacii urcuje sirku ochrannych pasiem Vyhlaska c. 35/1984 Zb.";
      }
      : text_part
      {
        label = "Poznamka: Na smerovo rozdelenych cestach sa vzdialenosti meraju od osi prilahlej vozovky.";
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
        label = "Nazov";
      }
      : text
      {
        label = "XXa";
        key = "nazov_zony_XX";
      }
    }

    //stlpec zo vzdialenostou ochranneho pasma
    : column
    {
      width = 50;
      : text
      {
        label = "Ochranne pasmo";
      }
      : text
      {
        label = "XX";
        key = "vzdialenostXX";
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
        key = "oznacitXX";
        label = "Zapisat";
      }
    }
    }
  }







  //XX riadok - XX
  : boxed_column
  {
    label = "XX";

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
        label = "Nazov";
      }
      : text
      {
        label = "VEREJNÝ VODOVOD A KANALIZÁCIA DO PRIEMERU 500 mm";
        key = "nazov_zony_XX";
      }
    }

    //stlpec zo vzdialenostou ochranneho pasma
    : column
    {
      width = 50;
      : text
      {
        label = "Ochranne pasmo";
      }
      : text
      {
        label = "1,5 m OD OSI";
        key = "vzdialenostXX";
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
        key = "oznacitXX";
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