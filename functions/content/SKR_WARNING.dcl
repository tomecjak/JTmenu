skr_warning : dialog {
  label = "Upozornenie pred spracovaním DWG";
  spacer;

  : boxed_column {
    label = "Dôležité upozornenie";
    width = 85;

    : text { label = "Tento skript deštruktívne upraví obsah vybraných DWG súborov."; }
    : text { label = "Rozbije bloky, texty, kóty, popisky a objekty v Model aj vo všetkých Layoutoch."; }
    : text { label = "Zároveň sa pokúsi odstrániť alebo konvertovať proxy a AEC objekty."; }
    : text { label = "Výsledné DWG môžu mať zmenený vzhľad, anotácie, fonty alebo štruktúru objektov."; }
    : text { label = "Pôvodné súbory ostanú zachované iba preto, že výstup sa ukladá pod nový názov."; }
    spacer;
    : text { label = "Pokračuj len vtedy, ak si si plne vedomý toho, čo tento skript urobí."; }
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
