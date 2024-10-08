//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -//
// Drainage.dcl
// (c) Copyright 2024 Tomecko Jakub
//
// Dialog pre funkciu Drainage.lsp 
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -//

Drainage //nazov dcl

: dialog
{
  //nazov dialogu
  label = "Vypocet odvodnenia";  

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
        label = "Vypocet odvodnenia je spracovany podla TP 063 - Odvodnenie mostov na pozemnych";  
      }
      //druhy riadok textu
      : text_part
      {
        label = "komunikaciach. Vypocet je mozne exportovat ako report vo formate csv.";  
      }
    } 
  }

  //druhy riadok dialogu - vypocet hltnosti odvodnovaca
  : boxed_row
  {
    label = "Vypocet hltnosti odvodnovaca";
    : column {   
      //vstupne hodnoty - prvy riadok
      : row 
      {
        : column
        {
          width = 20;
          : text 
          {  
            label = "Pozdlzny spad [%]";
          }
          : edit_box
          {
            key = "pozdlznySpad";
            value = "0.4";
          }
          : text 
          {  
            label = "Priecny spad [%]";
          }
          : edit_box
          {
            key = "priecnySpad";
            value = "2.5";
          } 
        }
        : column
        {
          width = 20;
          : text 
          {  
            label = "Umiest. od obrubnika [m]";
          }
          : edit_box
          {
            key = "umiestnenieOdObrubnika";
            value = "0.085";
          }
          : text 
          {  
            label = "Sucinitel drsnosti [-]";
          }
          : edit_box
          {
            key = "sucinitelDrsnosti";
            value = "0.015";
          } 
        }
        : column
        {
          width = 20;
          : text 
          {  
            label = "Sirka rozliatia [m]";
          }
          : edit_box
          {
            key = "sirkaRozliatia";
            value = "0.75";
          }
          : text 
          {  
            label = "Typ odvodnovaca";
          }
          : popup_list
          {
            key = "typOdvodnovaca";
            value = "0";
          } 
        }
      }
    }
  }

  //treti riadok dialogu - vysledok hltnosti odvodnovaca
  : boxed_row {
    label = "Vystup";
    //vystupne hodnoty
    : column {
      : row 
      {
        : text
        { 
          width = 25;
          label = "Podmienka max. hladiny vody: ";
        }
        : text
        { 
          width = 35;
          label = "";
          key = "vyhodnotenieMaxHladinyVody";
        } 
      }  
      : row 
      {
        : text
        { 
          width = 25;
          label = "Zvoleny typ odvodnovaca: ";
        }
        : text
        { 
          width = 35;
          label = "";
          key = "typNavrhovanehoOdvodnova";
        } 
      }  
      : row 
      {
        : text
        { 
          width = 25;
          label = "Hltnost odvodnovaca je: ";
        }
        : text
        { 
          width = 35;
          label = "";
          key = "vyslednaHltnostOdvodnovaca";
        } 
      }
    }  
  }

  //stvrty riadok dialogu - vypocet mnozstva odvodnovacov
  : boxed_row
  {
    label = "Vypocet mnozstva odvodnovacov";
    : column {   
      //vstupne hodnoty - prvy riadok
      : row 
      {
        : column
        {
          width = 30;
          : text 
          {  
            label = "Dlzka odvodnovanej plochy [m]";
          }
          : edit_box
          {
            key = "dlzkaOdvodnovacejPlochy";
            value = "62.4";
          }
          : text 
          {  
            label = "Sirka odvodnovanej plochy [m]";
          }
          : edit_box
          {
            key = "sirkaOdvodnovacejPlochy";
            value = "5.25";
          } 
        }
        : column
        {
          width = 30;
          : text 
          {  
            label = "Max. intenzita dazda [l/s.m2]";
          }
          : edit_box
          {
            key = "maxIntenziotaDazda";
            value = "0.0165";
          }
          : text 
          {  
            label = "Sucinitel odtoku";
          }
          : popup_list
          {
            key = "sucinitelOdtoku";
            value = "0";
          } 
        }
      }
    }
  }

  //piaty riadok dialogu - vysledok mnozstva odvodnovacov
  : boxed_row {
    label = "Vystup";
    //vystupne hodnoty
    : column {
      : row 
      {
        : text
        { 
          width = 35;
          label = "Maximalna vzdialenost odvodnovacou: ";
        }
        : text
        { 
          width = 25;
          label = "";
          key = "maxVzdialenostOdvodnovacou";
        } 
      }   
      : row 
      {
        : text
        { 
          width = 35;
          label = "Je potrebne odvodvodnenie izolacie: ";
        }
        : text
        { 
          width = 25;
          label = "";
          key = "odvodnenieIzolacie";
        } 
      }
    }     
  }

    //siesty riadok dialogu - posudenie kapacity potrubia
  : boxed_row
  {
    label = "Posudenie kapacity potrubia";
    : column {   
      //vstupne hodnoty - prvy riadok
      : row 
      {
        : column
        {
          width = 25;
          : text 
          {  
            label = "Vnut. prie. potrubia [m]";
          }
          : edit_box
          {
            key = "vnutornyPriemerPotrubia";
            value = "0.2";
          }
        }
        : column
        {
          width = 10;
          : text 
          {  
            label = "Sklon potrubia [%]";
          }
          : edit_box
          {
            key = "sklonPotrubia";
            value = "0.4";
          }
        }
        : column
        {
          width = 25;
          : text 
          {  
            label = "Typ/drsnost potrubia";
          }
          : popup_list
          {
            key = "drsnostPotrubia";
            value = "0";
          }
        }
      }
    }
  }

  //siedmi riadok dialogu - vysledok kapacity potrubia
  : boxed_row {
    label = "Vystup";
    //vystupne hodnoty
    : column {
      : row 
      {
        : text
        { 
          width = 25;
          label = "Navrhovane zberne potrubie: ";
        }
        : text
        { 
          width = 35;
          label = "";
          key = "vyhodnoteniePosudenieKapacityPotrubia";
        } 
      }  
      : row 
      {
        : text
        { 
          width = 25;
          label = "Objemovy prietok potrubia: ";
        }
        : text
        { 
          width = 35;
          label = "";
          key = "prietokPotrubia";
        } 
      } 
    }   
  }

  //posledny riadok dialogu s tlacidlami
  : row 
  {
    //tlacodlo napoveda
    : button 
    {  
      key = "napoveda";
      label = "Napoveda";
      is_default = false;
      mnemonic = "N";
    } 

    //tlacodlo report
    : button 
    {  
      key = "report";
      label = "Report";
      is_default = false;
      mnemonic = "R";
    } 

    //tlacodlo vypocitaj
    : button 
    {  
      key = "vypocitaj";
      label = "Vypocitaj";
      is_default = true;
      mnemonic = "V";
    } 

    //tlacodlo zavriet
    : button 
    {  
      key = "cancel";
      label = "Zavriet";
      is_cancel = true;
      mnemonic = "Z";
    }  
  }

}

/////// DIALOGOVE OKNO NAPOVEDA ///////

NapovedaDrainageDialog

: dialog
{
  label = "Napoveda";
  //Sucasti odvodnovacov
  : boxed_row
  {
    label = "Sucasti odvodnovacov";
    width = 100;
    : column {
      width = 15;
      : text_part { label = "Sedlo:"; }
      : text_part { label = "Tanier:"; }
      : text_part { label = "Ram + mreza:"; }
      : text_part { label = ""; }
      : text_part { label = ""; }
      : text_part { label = "Odvod. potrubie:"; }
      : text_part { label = ""; }
      : text_part { label = ""; }
      : text_part { label = "Zachytny kos:"; }
      : text_part { label = ""; }
      : text_part { label = ""; }
      : text_part { label = "Debniaca rura:"; }
      : text_part { label = ""; }
    }
    : column {
      width = 85;
      : text_part { label = "cast odvodnovaca, ktora je zabudovana do nosnej konstrukcie (musi byt vzdy osedene vodorovne)"; }
      : text_part { label = "cast odvodnovaca, ktora sa uklada na sedlo odvodnovaca"; }
      : text_part { label = "cast odvodnovaca ulozena na tanieri odvodnovaca; ram s mrezou musi tvorit jednotny celok"; }
      : text_part { label = "v uzatvorenom aj v otvorenom stavene; musi byt vyskovo rektifikovatelny, s nastavitelnym sklonom"; }
      : text_part { label = "v priecnom a pozdlznom smere vozvoky"; }
      : text_part { label = "cast odvodnovaca prostrednictvom ktoreho voda vteka do zberneho potrubia; oporuca sa vedenie"; }
      : text_part { label = "odvodnovacieho potrubia cez nosnu konstrukciu prostrednictvom zabudovanej debniacej rury,"; }
      : text_part { label = "zabezpecujucej vodotesnost systemu"; }
      : text_part { label = "pod mrezou odvodnovaca sa odporuca umiestnit zachytny kos, ktory zachytava vacsie necistoty;"; }
      : text_part { label = "zachytny kos je mozne umiestnit iba v priprade zabezpecenia pravidelnej udrzby - cistenie kosa,"; }
      : text_part { label = "aby nedoslo k upchatiu systemu odvodnenie"; }
      : text_part { label = "pri betonazi mostovky sa odporuca v mieste prestupu odvodnovaca nosnou konstrukciou osadit"; }
      : text_part { label = "debniaca rura vzdy o vyssom priemere ako je vytok sedla odvodnovaca (Priemer rury + 50 mm)"; }
    }
  }

  //Navrh odvodnenia
  : boxed_column
  {
    label = "Navrh odvodnenie";
    width = 100;
    : text_part { label = "1. Druh, velkost a vzajomna vzdialenost odvodnovacou sa navrhne na zaklade vypoctu odvodnenia."; }
    : text_part { label = "2. Pre mostny objekt sa navrhne komplexny system odvodnenia (odvodnovace, odvodnovacie potrubie,"; }
    : text_part { label = "    zberne potrubie, pozdlzna drenaz, priecna drenaz a odvodnenie povrchu izolacie)."; }
    : text_part { label = "3. Odvodnenie sa navrhne tak, aby pri navrhovom mnozstve zrazkovej vody v rovnomernom prietoku"; }
    : text_part { label = "    prudiaca voda nezasiahla do jazdnych pruhov. Max. sirka rozliatia v spev. krajnici je 1 m."; }
    : text_part { label = "4. Navrh hltnosti je zavisli od:"; }
    : text_part { label = "    a) pozdlzneho sklonu vozovky"; }
    : text_part { label = "    b) priecneho sklonu voozvky"; }
    : text_part { label = "    c) pripustnej sirky rozliatia pri obrubniku"; }
    : text_part { label = "    d) tvaru a konstrukcie odvodnovacieho prizku"; }
    : text_part { label = "    e) konstrukcie odvodnovaca"; }
    : text_part { label = "    Pre dany tvar a konstrukciu odvodnovacieho pruzku a odvodnovaca je jeho hltnost priamo zavisla"; }
    : text_part { label = "    na strednej prierezovej rychlosti vody na vtoku do odvodnovaca a na vyske vodnej vrstvy v jeho osi."; }
    : text_part { label = "5. Odvodnenie chodnika sa spravidla zabezpeci navrhom priecneho sklonu smerom k odvodnovaciemu pruzku."; }
    : text_part { label = "6. Trieda odvodnovaca z pohladu zatazenia na mrezu odvodnovaca sa stanovuje v sulate s STN EN 124."; }
    : text_part { label = "    Pre mosty sa stanovuje trieda D 400."; }
    : text_part { label = "7. Pri kratsich mostoch (dlzky spravidla do 20 m, resp. 150 m2 plochy nosnej konstrukcie) je dovolene"; }
    : text_part { label = "    navrhnut odvodnenie mosta bez odvodnovacou, pricom je potrebne respektovat sklon nivelety na moste."; }
    : text_part { label = "    a prihliada sa na intenzitu cestnej premavky."; }
  }

  //Popis kategorie ploch
  : boxed_row
  {
    label = "Popis kategorie ploch pre sucinitel odtoku";
    width = 100;
    : column {
      width = 15;
      : text_part { label = "Kategoia A:"; }
      : text_part { label = "Kategoia B:"; }
      : text_part { label = "Kategoia C:"; }
    }
    : column {
      width = 85;
      : text_part { label = "pre zastavane plochy a malo priepustne spevnene plochy (strechy, bet., asfaltove povrchy a pod.)"; }
      : text_part { label = "pre ciastocne priepustne spevnene plochy (dlazby s vysparovanym pieskom, strkom a pod.)"; }
      : text_part { label = "pre dobre priepustne plochy pokryte vegetaciou (travniky, zahrady a pod.)"; }
    }
  }

  //Drsnost potrubia
  : boxed_column
  {
    label = "Drsnost potrubia";
    width = 100;
    : text_part { label = "Drsnost potrubia pre jednotlive materialy bol stanoveny podla Manninga."; }
    : text_part { label = "Zdroj: https://vodovod.info/index.php/extra/tabulky/196-drsnost-potrubi"; }
  }

  : button
  {
    key = "zatvoritNapovedu";
    label = "Zavriet";
    is_default = true;
    is_cancel = true;
    width = 15;
    fixed_width = true;
    alignment = centered;
  }
}

/////// DIALOGOVE OKNO REPORT ///////

ReportDrainageDialog

: dialog
{
  label = "Report";
  //prvy riadok reportu - vypocet hltnosti odvodnenia
  : boxed_row
  {
    label = "Vypocet hltnosti odvodnenia";
    //prvy slpec - nazov
    : column {
      width = 44;
      : text {label = "Pozdlzny spad [vstupna hodnota]";}
      : text {label = "Priecny spad [vstupna hodnota]";}
      : text {label = "Umiestnenie od obrubnika [vstupna hodnota]";}
      : text {label = "Sucinitel drsnosti [vstupna hodnota]";}
      : text {label = "Sirka rozliatia [vstupna hodnota]";}
      : text {label = "Sirka (ramu) odvodnovaca [vstupna hodnota]";}
      : text {label = "Vyska vody pri obrubniku";}
      : text {label = "Plocha vody v rigole (odvod. zlab)";}
      : text {label = "Omoceny obvod";}
      : text {label = "Hydraulicky polomer";}
      : text {label = "Rychlostny sucinitel";}
      : text {label = "Rychlost na vtoku";}
      : text {label = "Mnozstvo vody pretekajuci rigolom";}
      : text {label = "Rychlost vody na povrchu";}
      : text {label = "Vyska vody v osi odvodnovaca";}
      : text {label = "Max. vyska vody v osi odvodnovaca";}
      : text {label = "Posudenie max. vysky vody";}
      : text {label = "Sucinitel bocneho natoku";}
      : text {label = "Prirahla sirka";}
      : text {label = "Spoluposobiaca sirka";}
      : text {label = "Priemerna vyska vody";}
      : text {label = "Plocha vodnej vrstvy prit. k odvod.";}
      : text {label = "Mnozstvo vody vtekajucej do odvod.";}
    }
    //druhy slpec - oznacenie
    : column {
      width = 15;
      : text {label = "Ppd"; alignment = centered;}
      : text {label = "Ppr"; alignment = centered;}
      : text {label = "bobr"; alignment = centered;}
      : text {label = "n"; alignment = centered;}
      : text {label = "B"; alignment = centered;}
      : text {label = "a"; alignment = centered;}
      : text {label = "h"; alignment = centered;}
      : text {label = "A"; alignment = centered;}
      : text {label = "O"; alignment = centered;}
      : text {label = "R"; alignment = centered;}
      : text {label = "C"; alignment = centered;}
      : text {label = "v"; alignment = centered;}
      : text {label = "Q"; alignment = centered;}
      : text {label = "v'"; alignment = centered;}
      : text {label = "h'1"; alignment = centered;}
      : text {label = "hmax"; alignment = centered;}
      : text {label = "-"; alignment = centered;}
      : text {label = "k"; alignment = centered;}
      : text {label = "k.h1"; alignment = centered;}
      : text {label = "a1"; alignment = centered;}
      : text {label = "@h'1"; alignment = centered;}
      : text {label = "1A"; alignment = centered;}
      : text {label = "Hod"; alignment = centered;} 
    }
    //treti slpec - hodnota
    : column {
      width = 10;
      : text {label = ""; key = "report_pozdlznySpad"; alignment = right;}
      : text {label = ""; key = "report_priecnySpad"; alignment = right;}
      : text {label = ""; key = "report_umiestnenieObrubnika"; alignment = right;}
      : text {label = ""; key = "report_sucinitelDrsnosti"; alignment = right;}
      : text {label = ""; key = "report_sirkaRozliatia"; alignment = right;}
      : text {label = ""; key = "report_sirkaOdvodnovaca"; alignment = right;}
      : text {label = ""; key = "report_vyskaVodyPriObrubniku"; alignment = right;}
      : text {label = ""; key = "report_plochaVodyVRigole"; alignment = right;}
      : text {label = ""; key = "report_omocenyObvod"; alignment = right;}
      : text {label = ""; key = "report_hydraulickyPolomer"; alignment = right;}
      : text {label = ""; key = "report_rychlostnySucinitel"; alignment = right;}
      : text {label = ""; key = "report_rychlostNaVtoku"; alignment = right;}
      : text {label = ""; key = "report_mnozstvoVodyPretekajucejRigolom"; alignment = right;}
      : text {label = ""; key = "report_rychlostVodyNaPovrchu"; alignment = right;}
      : text {label = ""; key = "report_vyskaVodyVOsiOdvodnovaca"; alignment = right;}
      : text {label = ""; key = "report_maxVyskaVodyVOsiOdvodnovaca"; alignment = right;}
      : text {label = ""; key = "report_posudenieVyskyVodyVOsiOdvodnenia"; alignment = right;}
      : text {label = ""; key = "report_sucinitelBocnehoNatoko"; alignment = right;}
      : text {label = ""; key = "report_prirahlaSirka"; alignment = right;}
      : text {label = ""; key = "report_spoluposobiacaSirka"; alignment = right;}
      : text {label = ""; key = "report_priemernaVyskaVody"; alignment = right;}
      : text {label = ""; key = "report_plochaVodnejVrstvyPritekajucejOdvodnovacu"; alignment = right;}
      : text {label = ""; key = "report_mnozstvoVodyVtekajucejDoOdvodnovaca"; alignment = right;}
    }
    //stvrty slpec - jednotka
    : column {
      width = 5;
      : text {label = "%";}
      : text {label = "%";}
      : text {label = "m";}
      : text {label = "-";}
      : text {label = "m";}
      : text {label = "m";}
      : text {label = "m";}
      : text {label = "m2";}
      : text {label = "m";}
      : text {label = "m";}
      : text {label = "-";}
      : text {label = "m/s";}
      : text {label = "l/s";}
      : text {label = "m/s";}
      : text {label = "m";}
      : text {label = "m";}
      : text {label = "-";}
      : text {label = "-";}
      : text {label = "m";}
      : text {label = "m";}
      : text {label = "m";}
      : text {label = "m2";}
      : text {label = "l/s";} 
    }
    //piaty slpec - vzorec
    : column {
      width = 25;
      : text {label = "";}
      : text {label = "";}
      : text {label = "";}
      : text {label = "";}
      : text {label = "";}
      : text {label = "";}
      : text {label = "h=B.Ppr";}
      : text {label = "A=0.5.B.h";}
      : text {label = "O=B+h";}
      : text {label = "R=A/O";}
      : text {label = "C=(R^1/6)/n";}
      : text {label = "v=C.(R^1/2).(Ppd^1/2)";}
      : text {label = "Q=A.v.1000";}
      : text {label = "v'=v.1,15<1,0 (1,5)";}
      : text {label = "h'1=(B-bobr-a/2).Ppr";}
      : text {label = "";}
      : text {label = "h'1<hmax";}
      : text {label = "k=5/v";}
      : text {label = "k.h1";}
      : text {label = "a1=k.h1+a+min(bobr;k.h1)";}
      : text {label = "@h'1=(B-a1/2).Ppr";}
      : text {label = "A1=a1.@h'1";}
      : text {label = "Hod=A1.v.1000";} 
    }
  }

  //druhy riadok reportu - vypocet mnozstva odvodnovacov
  : boxed_row
  {
    label = "Vypocet mnozstva odvodnovacov";
    //prvy slpec - nazov
    : column {
      width = 45;
      : text {label = "Dlzka odvodnovanej plochy [vstupna hodnota]";}
      : text {label = "Sirka odvodnovanej plochy [vstupna hodnota]";}
      : text {label = "Max. privalova intenzita dazda [vstupna hodnota]";}
      : text {label = "Sucinitel odtoku [vstupna hodnota]";}
      : text {label = "Odvodnovana plocha mosta";}
      : text {label = "Mnozstvo odvadzanej vody";}
      : text {label = "Stupen bezpecnosti";}
      : text {label = "Vzdialenost odvodnovacov";}
    }
    //druhy slpec - oznacenie
    : column {
      width = 15;
      : text {label = "l"; alignment = centered;}
      : text {label = "s"; alignment = centered;}
      : text {label = "q"; alignment = centered;}
      : text {label = "fi"; alignment = centered;}
      : text {label = "Fm"; alignment = centered;}
      : text {label = "Qm"; alignment = centered;}
      : text {label = "s"; alignment = centered;}
      : text {label = "Lodv"; alignment = centered;}
    }
    //treti slpec - hodnota
    : column {
      width = 10;
      : text {label = ""; key = "report_dlzkaOdvodnovanejPlochy"; alignment = right;}
      : text {label = ""; key = "report_sirkaOdvodnovanejPlochy"; alignment = right;} 
      : text {label = ""; key = "report_maxIntenzitaDazda"; alignment = right;} 
      : text {label = ""; key = "report_sucinitelOdtoku"; alignment = right;} 
      : text {label = ""; key = "report_odvodnovanaPlocha"; alignment = right;} 
      : text {label = ""; key = "report_mnozstvoOdvadzanejVody"; alignment = right;} 
      : text {label = ""; key = "report_stupenBezpecnosti"; alignment = right;} 
      : text {label = ""; key = "report_vzdialenostOdvodnovacou"; alignment = right;} 
    }
    //stvrty slpec - jednotka
    : column {
      width = 5;
      : text {label = "m";}
      : text {label = "m";}
      : text {label = "l/s.m2";}
      : text {label = "-";}
      : text {label = "m2";}
      : text {label = "l/s";}
      : text {label = "-";}
      : text {label = "m";} 
    }
    //piaty slpec - vzorec
    : column {
      width = 25;
      : text {label = "";}
      : text {label = "";}
      : text {label = "";}
      : text {label = "";}
      : text {label = "Fm=s.l";}
      : text {label = "Qm=Fm.q.fi";}
      : text {label = "";}
      : text {label = "Lodv=Hodv/(q.s.fi).s";}
    }
  }

  //treti riadok reportu - posudenie kapacity potrubia
  : boxed_row
  {
    label = "Posudenie kapacity potrubie";
    //prvy slpec - nazov
    : column {
      width = 44;
      : text {label = "Vnutorny priemer potrubia [vstupna hodnota]";}
      : text {label = "Sklon potrubia [vstupna hodnota]";}
      : text {label = "Drsnost potrubia [vstupna hodnota]";}
      : text {label = "Prietokova plocha potrubia";}
      : text {label = "Omoceny obvod";}
      : text {label = "Hydraulicky polomer";}
      : text {label = "Rychlostny sucinitel";}
      : text {label = "Stredna profilova rychlost";}
      : text {label = "Objemovy prietok potrubia";}
      : text {label = "Posudenie potrubia";}
    }
    //druhy slpec - oznacenie
    : column {
      width = 15;
      : text {label = "dpot"; alignment = centered;}
      : text {label = "ipot"; alignment = centered;}
      : text {label = "n"; alignment = centered;}
      : text {label = "Spot"; alignment = centered;}
      : text {label = "Opot"; alignment = centered;}
      : text {label = "Rpot"; alignment = centered;}
      : text {label = "c"; alignment = centered;}
      : text {label = "vpot"; alignment = centered;}
      : text {label = "Qpot"; alignment = centered;}
      : text {label = "-"; alignment = centered;} 
    }
    //treti slpec - hodnota
    : column {
      width = 10;
      : text {label = ""; key = "report_vnutornyPriemerPotrubia"; alignment = right;}
      : text {label = ""; key = "report_sklonPotrubia"; alignment = right;} 
      : text {label = ""; key = "report_drsnostPotrubia"; alignment = right;} 
      : text {label = ""; key = "report_prietokovaPlochaPotrubia"; alignment = right;} 
      : text {label = ""; key = "report_omocenyObvodPotrubia"; alignment = right;} 
      : text {label = ""; key = "report_hydraulickyPolomerPotrubia"; alignment = right;} 
      : text {label = ""; key = "report_rychlostnySucinitelPotrubia"; alignment = right;} 
      : text {label = ""; key = "report_strednaProfilovaRychlost"; alignment = right;} 
      : text {label = ""; key = "report_objemovyPrietokPotrubia"; alignment = right;} 
      : text {label = ""; key = "report_posudenieKapacityPotrubia"; alignment = right;}  
    }
    //stvrty slpec - jednotka
    : column {
      width = 5;
      : text {label = "m";}
      : text {label = "%";}
      : text {label = "";}
      : text {label = "m2";}
      : text {label = "m";}
      : text {label = "m";}
      : text {label = "";}
      : text {label = "m/s";}
      : text {label = "l/s";}
      : text {label = "";}
    }
    //piaty slpec - vzorec
    : column {
      width = 25;
      : text {label = "";}
      : text {label = "";}
      : text {label = "";}
      : text {label = "Spot=pi.(dpot^2)/4";}
      : text {label = "Opot=pi.dpot";}
      : text {label = "Rpot=Spot/Opot";}
      : text {label = "c=(1/n).Rpot^1/6";}
      : text {label = "vpot=c.(Rpot.ipot)^1/2";}
      : text {label = "Qpot=Spot.vpot";}
      : text {label = "Qpot>Qm";}
    }
  }

  : row {
    width = 30;
    fixed_width = true;
    alignment = centered;
    //tlacodlo report
    : button 
    {  
      key = "reportExport";
      label = "Exportovat";
      is_default = false;
      mnemonic = "E";
      width = 15;
      fixed_width = true;
    }

    : button
    {
      key = "zatvoritReport";
      label = "Zavriet";
      is_default = true;
      is_cancel = true;
      width = 15;
      fixed_width = true;
    }
  }
}