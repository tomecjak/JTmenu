Vytycenie //nazov dcl

: dialog
{
  //nazov dialogu
  label = "Vytycenie bodov";


  //prvy stlpec prveho riadku
  : row
  {
    //tlacidla vybrat krivku
    : button 
    {
      key = "vybratPolyline";
      label = "Vybrat polyline";
      is_default = true;
      mnemonic = "V";
    }
  }  

  //druhy stlpec prveho riadku
  : boxed_row
  { 
    //nazov riadku
    label = "Pocet bodov/suradnic";
    //stavovy riadok o vybranej krivke
    : text
    {
      label = "";
      key = "polylineInfoText";
    }
  }

  //treti riadok
  : boxed_column
  {
    //nazov riadku
    label = "Poznamka";
    : row {
    : text
    {
      label = "Suradnice ulozite ako csv subor,";
    }
    }
    : row {
    : text 
    {
      label = "ktory je mozne otvorit v exceli.";
    }
    }
  }

  //stvrti riadok
  : row
  {
    //tlacidlo ulozit
    : button
    {
      key = "ulozit";
      label = "Ulozit";
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