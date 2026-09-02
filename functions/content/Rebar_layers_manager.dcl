//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -//
// Rebar_layers_manager.dcl
// (c) Copyright 2026 Tomecko Jakub
//
// Dialog pre funkciu Rebar_layers_manager.lsp
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -//

Rebar_layers_manager //nazov dcl

: dialog
{
  //nazov dialogu
  label = "Sprava hladin vystuze";

  //prvy riadok dialogu - zoznam hladin
  : boxed_column
  {
    label = "Hladiny vystuze vo vykrese";

    //hlavicka stlpcov zoznamu
    : text
    {
      key = "hdr";
      label = "Nazov hladiny        | Spolu | Blok | Plin | Priemer";
    }

    //zoznam hladin vystuze
    : list_box
    {
      key = "lay_list";
      width = 56;
      height = 16;
      multiple_select = false;
      fixed_width_font = true;
    }

    //informacny riadok
    : text
    {
      key = "info";
      label = "";
      width = 56;
    }
  }

  //druhy riadok dialogu - vytvorenie novych hladin
  : boxed_column
  {
    label = "Vytvorenie a cislovanie hladin";

    //typ vytvaranych hladin
    : radio_row
    {
      key = "typ";
      : radio_button
      {
        key = "t_b";
        label = "Vystuz (-B)";
        value = "1";
      }
      : radio_button
      {
        key = "t_bs";
        label = "Spony (-BS)";
      }
    }

    //odkial sa ma zacat cislovat
    : radio_column
    {
      key = "rezim";
      : radio_button
      {
        key = "r_end";
        label = "Od poslednej polozky";
        value = "1";
      }
      : radio_button
      {
        key = "r_num";
        label = "Od zadaneho cisla (precisluje existujuce)";
      }
    }

    //pocet hladin, pociatocne cislo a spustenie
    : row
    {
      : edit_box
      {
        key = "pocet";
        label = "Pocet hladin:";
        edit_width = 5;
        value = "1";
      }
      : edit_box
      {
        key = "odcisla";
        label = "Od cisla polozky:";
        edit_width = 5;
      }
      : button
      {
        key = "create";
        label = "Vytvorit hladiny";
        width = 18;
      }
    }

    //vysvetlivka k rezimu cislovania
    : text
    {
      key = "hint";
      label = "";
    }

    //precislovanie celej rady od 1 po koniec
    : row
    {
      : button
      {
        key = "renum";
        label = "Precislovat od 1 po koniec";
        width = 28;
      }
      : text
      {
        label = "Zaplni medzery v cislovani zvoleneho typu.";
      }
    }
  }

  //treti riadok dialogu - akcie nad vybranou hladinou
  : row
  {
    : button
    {
      key = "accept";
      label = "Oznacit prvky";
      is_default = true;
      width = 18;
    }
    : button
    {
      key = "setcur";
      label = "Nastavit ako aktualnu";
      width = 24;
    }
    : button
    {
      key = "refresh";
      label = "Obnovit";
      width = 14;
    }
    : button
    {
      key = "cancel";
      label = "Zavriet";
      is_cancel = true;
      width = 14;
    }
  }

  //poznamka pod tlacidlami
  : text
  {
    label = "Dvojklik na riadok = oznacenie prvkov v modeli.";
    alignment = centered;
  }
}

//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -//
//                             End of File                               //
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -//
