Layout_update //nazov dcl

: dialog
{
  //nazov dialogu
  label = "Layout nastavenia";  

  //prvy riadok dialogu s checkboxmi
  : boxed_column
  {
    label = "Aktualizacia rozpisky";

    //checkbox 01 - Cislo objektu
    : toggle
    { 
      key = "cisloObjektu";
      label = "Cislo objektu";
    }

    //checkbox 02 - Velkost vykresu
    : toggle
    { 
      key = "velkostVykresu";
      label = "Velkost vykresu";
    }

    //checkbox 03 - Mierka vykresu
    : toggle
    { 
      key = "mierkaVykresu";
      label = "Mierka vykresy";
    }

    //checkbox 04 - Nazov vykresu
    : toggle
    { 
      key = "nazovVykresu";
      label = "Nazov vykresy";
    }

    //checkbox 05 - Cislo vykresu
    : toggle
    { 
      key = "cisloVykresu";
      label = "Cislo vykresy";
    }
  }

  //druhy riadok dialogu s nastavenim mena pre vyhotovil
  : boxed_column
  {
    label = "Aktualizacia vyhotovitela";

    //vstupne pole pre napisanie mena
    : edit_box 
    {
      key = "vykresVypracoval";
    }

    //checkbox - aktualizacia vyhotovitela
    : toggle
    {
      key = "vykresVypracovalAktualizacia";
      label = "Aktualizovat vyhotovela";
    }
  }

  //treti riadok dialogu s nastavenim formatu cislovania vykresu
  : boxed_column
  {
    label = "Format cislovania vykresu";

    //nastavenie popup-listu
    : popup_list
     {
      label = "Pocet cislic:";
      key = "formatCislovania";
      value = "0";
     }
  }

  //stvrty riadok dialogu s ukazkou formatovania nazvu suboru
  : boxed_column
  {
    label = "Priklady naformatovania nazvu suboru";

    //checkbox - velkost pisma
    : toggle
    {
      key = "vykresNazovUppercase";
      label = "Uppercase nazov";
      value = "1";
    }

    : text
    {
      label = "2xx-xx_xx_Nazov vykresu";
    }
    : text
    {
      label = "2xx-xx_xxx_Nazov vykresu";
    }
    : text
    {
      label = "Namiesto znaku podtrznika moze byt aj medzera.";
    }
  }

  //piaty riadok dialogu s nastavenim pre premovanie tabu layoutu
  : boxed_column
  {
    label = "Premenovanie layoutu podla rozmeru";

    //checkbox - aktualizacia vyhotovitela
    : toggle
    {
      key = "layoutRename";
      label = "Ano";
    }
  }

  //siesty riadok dialogu s tlacidlami pre oznacenie
  : row
  {
    //tlacidlo oznacit vsetko
    : button
    {
      key = "oznacitVsetko";
      label = "Oznacit vsetko";
      width = 20;
    }  

    //tlacidlo odznacit vsetko
    : button
    {
      key = "odznacitVsetko";
      label = "Odznacit vsetko";
      width = 20;
    }
  }

  //posledny riadok dialogu s tlacidlami
  : row
  {
    //tlacidlo aktualizovat
    : button
    {
      key = "aktualizovat";
      label = "Aktualizovat";
      width = 20;
      is_default = true;
    }  

    //tlacidlo zavriet
    : button
    {
      key = "cancel";
      label = "Zavriet";
      width = 20;
      is_cancel = true;
    }
  }
}

