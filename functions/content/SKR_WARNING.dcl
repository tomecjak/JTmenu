skr_warning : dialog {
  label = "Upozornenie pred spracovaním DWG";
  spacer;

  : boxed_column {
    label = "Dôležité upozornenie";
    width = 90;

    : text { label = "Tento skript deštruktívne prepíše pôvodné DWG súbory na ich pôvodnom mieste."; }
    : text { label = "Rozbije bloky, texty, kóty, popisky a objekty v Model aj vo všetkých Layoutoch."; }
    : text { label = "Zároveň sa pokúsi odstrániť alebo konvertovať proxy a AEC objekty."; }
    : text { label = "Nebude vytvorený žiadny nový názov súboru ani žiadny suffix."; }
    : text { label = "Výsledné DWG môžu mať zmenený vzhľad, anotácie, fonty alebo štruktúru objektov."; }
    spacer;
    : text { label = "Pokračuj len vtedy, ak si si plne vedomý toho, že prepíšeš originálne súbory."; }
  }

  spacer;

  : row {
    alignment = centered;
    : button {
      key = "accept";
      label = "Pokračovať";
      is_default = true;
      fixed_width = true;
      width = 16;
    }
    : button {
      key = "cancel";
      label = "Zrušiť";
      is_cancel = true;
      fixed_width = true;
      width = 16;
    }
  }

  spacer;
}
