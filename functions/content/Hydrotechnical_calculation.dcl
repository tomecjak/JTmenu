//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -//
// Hydrotechnical_calculation.dcl
// (c) Copyright 2025 Tomecko Jakub
//
// Dialog pre funkciu Hydrotechnical_calculation.lsp 
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -//

Hydrotechnical_calculation //nazov dcl

: dialog
{
  //nazov dialogu
  label = "Hydrotechnicky vypocet";

  //pravy riadok dialogu
  : boxed_row
  {
    label = "Poznamka";

    //poznamka
    : paragraph
    {
      //pravy riadok textu
      : text_part
      {
        label = "Podklady pre vypocet:";
      }
      //druhy riadok textu
      : text_part
      {
        label = "Doc. Ing. Stanislav Sterba - Zaklady vodohospodarskeho inzinierstva, 1998";
      }
    }
  }

  //durhy riadok dialogu - vyber polyliny
  : boxed_row
  {
    label = "Poznamka";
    : button
    {
      key = "polylinaKoryta";
      label = "Vyberte polylinu";
    }
  }

  //druhy riadok dialogu - vstupne hodnoty pre vypocet
  : boxed_row
  {
    label = "Vypocet pozdlzneho sklonu koryta";
    : column
    {
      : row
      {
        : column
        {
          width = 15;
          : text
          {
            label = "H na zac. koryta [m]";
          }
          : edit_box
          {
            key = "vyskaNaZaciatkuKoryta";
            value = "201";
          }
          : text
          {
            label = "Stupen drsnosti koryta [-]";
          }
          : edit_box
          {
            key = "stupenDrsnostiKoryta";
            value = "1";
          }
        }
        : column
        {
          width = 15;
          : text
          {
            label = "H na kon. koryta [m]";
          }
          : edit_box
          {
            key = "vyskaNaKonciKoryta";
            value = "202";
          }
          : text
          {
            label = "Pritocna plocha [m2]";
          }
          : edit_box
          {
            key = "pritocnaPlochaKoryta";
            value = "1";
          }
        }
        : column
        {
          width = 15;

          : text
          {
            label = "Dlzka koryta [m]";
          }
          : edit_box
          {
            key = "dlzkaKoryta";
            value = "1";
          }
          : text
          {
            label = "Omoceny obvod [m]";
          }
          : edit_box
          {
            key = "omocvenyObvodKoryta";
            value = "1";
          }
        }
      }
      : spacer { height = 0.5; }
      : row
      {
        : text
        {
          label = "Hodnota prietoku [m3/s]";
        }
      }
      : row
      {
        : column
        {
          : text
          {
            label = "Q1";
          }
          : edit_box
          {
            key = "hodnotaPrietokuKorytaQ1";
            value = "1";
          }
        }
        : column
        {
          : text
          {
            label = "Q2";
          }
          : edit_box
          {
            key = "hodnotaPrietokuKorytaQ2";
            value = "1";
          }
        }
        : column
        {
          : text
          {
            label = "Q5";
          }
          : edit_box
          {
            key = "hodnotaPrietokuKorytaQ5";
            value = "1";
          }
        }
        : column
        {
          width = 2;
          fixed_width = true;
          : text
          {
            label = "Q10";
          }
          : edit_box
          {
            key = "hodnotaPrietokuKorytaQ10";
            value = "1";
          }
        }
      }
      : row
      {
        : column
        {
          : text
          {
            label = "Q20";
          }
          : edit_box
          {
            key = "hodnotaPrietokuKorytaQ20";
            value = "1";
          }
        }
        : column
        {
          : text
          {
            label = "Q50";
          }
          : edit_box
          {
            key = "hodnotaPrietokuKorytaQ50";
            value = "1";
          }
        }
        : column
        {
          : text
          {
            label = "Q100";
          }
          : edit_box
          {
            key = "hodnotaPrietokuKorytaQ100";
            value = "1";
          }
        }
      }
    }
  }

  //treti riadok dialogu - stupen drsnosti n
  : boxed_row
  {
    label = "Stupen drsnosti prirodzenych tokov";
    
    //text
    :column
    {
      : paragraph
      {
        : text_part
        {
          label = "Ciste koryto s plynulou zmenou trasy, pravidelny profil";
        }
        : text_part
        {
          label = "To iste, ale s riasami a kamenmi";
        }
        : text_part
        {
          label = "Ciste, klukate koryto s plytcinami a tonami";
        }
        : text_part
        {
          label = "To iste, s pritomnostou kamenov a rias";
        }
        : text_part
        {
          label = "Ciste, klukate koryto s plytcinami a vymolmi, vacsie mnozstvo kamenov";
        }
        : text_part
        {
          label = "Zarastene koryto s hlbokymi vymolmi, pri malych rychlostiach vody";
        }
        : text_part
        {
          label = "Velmi zarastene koryto s hlbokymi vymolmi, alebo kanaly silne zarastene krovim";
        }
        : text_part
        {
          label = "Toky s doboru udrzbou, bez porastu na svahoch, svahy zvacsa strme,";
        }
        : text_part
        {
          label = "brehoba vegetacia je zatapana voodu len pri velkych prietokoch:";
        }
        : text_part
        {
          label = "  - dno prescite, kamene sa vyskytuju zriedkavo";
        }
        : text_part
        {
          label = "  - dno strkovite, velke mnozstvo velkych kamenov";
        }
      }
    }

    //hodnota
    :column
    {
 
      fixed_width = true;
      : paragraph
      {
        : text_part
        {
          label = "0,025 - 0,033";
        }
        : text_part
        {
          label = "0,03 - 0,04";
        }
        : text_part
        {
          label = "0,033 - 0,045";
        }
        : text_part
        {
          label = "0,035 - 0,055";
        }
        : text_part
        {
          label = "0,045 - 0,06";
        }
        : text_part
        {
          label = "0,05 - 0,08";
        }
        : text_part
        {
          label = "0,075 - 0,15";
        }
        : text_part
        {
          label = "";
        }
        : text_part
        {
          label = "";
        }
        : text_part
        {
          label = "0,03 - 0,05";
        }
        : text_part
        {
          label = "0,04 - 0,07";
        }
      }
    }
  }

  //stvrty riadok dialogu - vystupne hodnoty
  : boxed_row
  {
    label = "Vystupy";
    //vystupne hodnoty
    : column
    {
      : row
      {
        : text
        {
          width = 10;
          label = "Vyskovy rodiel koryta:";
        }
        : text
        {
          width = 10;
          label = "";
          key = "vyskovyRozdielKoryta";
        }
      }
      : row
      {
        : text
        {
          width = 10;
          label = "Vypocitany sklon koryta:";
        }
        : text
        {
          width = 10;
          label = "";
          key = "vypocitanySklonKoryta";
        }
      }
      : row
      {
        : text
        {
          width = 10;
          label = "Hydraulicky polomer:";
        }
        : text
        {
          width = 10;
          label = "";
          key = "hydrailickyPolomer";
        }
      }
      : row
      {
        : text
        {
          width = 10;
          label = "Rychlostni sucinitel:";
        }
        : text
        {
          width = 10;
          label = "";
          key = "rychlostniSucinitel";
        }
      }
      : row
      {
        : text
        {
          width = 10;
          label = "Prietokove mnoztvo:";
        }
        : text
        {
          width = 10;
          label = "";
          key = "prietokoveMnozstvo";
        }
      }
      : row
      {
        : text
        {
          width = 10;
          label = "Navrhovany profil koryta:";
        }
        : text
        {
          width = 10;
          label = "";
          key = "vyhodnoteniePosudeniaPrietokuKoryta";
        }
      }
    }
  }

  //posledny riadok dialogu s tlacidlami
  : row
  {
    //tlacidlo report
    : button
    {
      key = "report";
      label = "Report";
      is_default = false;
      mnemonic = "R";
    }

    //tlacidlo vypocitaj
    : button
    {
      key = "vypocitaj";
      label = "Vypocitaj";
      is_default = true;
      mnemonic = "V";
    }

    //tlacidlo zavier
    : button
    {
      key = "cancel";
      label = "Zavriet";
      is_cancel = true;
      mnemonic = "Z";
    }
  }
}
