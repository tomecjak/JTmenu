Vytycenie //nazov dcl

: dialog
{
  //nazov dialogu
  label = "Vytycenie";

  //prvy riadok
  : row
  {
    //prvy stlpec prveho riadku
    : column
    {
      //tlacidla vybrat krivku
      : button 
      {
        key = "vybratPolyline";
        label = "Vybrat polyline";
      }
    }  

    //druhy stlpec prveho riadku
    : column
    { 
      //stavovy riadok o vybranej krivke
      : text
      {
        label = "Test";
        key = "polylineInfoText";
      }
    }
  }

  //druhy riadok
  : boxed_row
  {
    //nazov riadku
    label = "Poznamka";
    : text 
    {
      label = "";
    }
  }

  //treti riadok
  : row
  {
    //tlacidlo ulozit
    : button
    {
      key = "ulozit";
      label = "Ulozit";
      is_default = true;
      mnemonic = "U";
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