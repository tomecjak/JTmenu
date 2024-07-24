Layout_setting //nazov dcl

: dialog
{
  //nazov dialogu
  label = "Layout nastavenia";  

  //posledny riadok dialogu s tlacidlami
  : row
  {
    //tlacidlo aktualizovat
    : button
    {
      key = "aktualizovat";
      label = "Aktualizovat";
      is_default = true;
    }  

    //tlacidlo zavriet
    : button
    {
      key = "cancel";
      label = "Zavriet";
      is_cancel = true;
    }
  }
}