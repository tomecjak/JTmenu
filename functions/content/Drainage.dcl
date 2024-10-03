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
        label = "1. riadok - doplnit.";  
      }
      //druhy riadok textu
      : text_part
      {
        label = "2. riadok - doplnit.";  
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
            label = "Sirka ramu odvod. [m]";
          }
          : edit_box
          {
            key = "sirkaRamuOdvodnovaca";
            value = "0.33";
          } 
        }
      }
    }
  }

  //xxxxx
  : boxed_row {
    label = "xxx";
      //vystupne hodnoty
      : row 
      {
        : text
        { 
          label = "yyy:";
        }
        : text
        { 
          label = "";
          key = "";
        } 
      }    
  }

  //treti riadok dialogu - vypocet mnozstva odvodnovacov
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
            label = "xxx";
          }
          : edit_box
          {
            label = "";
            key = "";
            value = "";
          }
          : text 
          {  
            label = "xxx";
          }
          : edit_box
          {
            label = "";
            key = "";
            value = "";
          } 
        }
        : column
        {
          width = 30;
          : text 
          {  
            label = "xxx";
          }
          : edit_box
          {
            label = "";
            key = "";
            value = "";
          }
          : text 
          {  
            label = "xxx";
          }
          : edit_box
          {
            label = "";
            key = "";
            value = "";
          } 
        }
      }
    }
  }

  //xxxxx
  : boxed_row {
    label = "xxx";
      //vystupne hodnoty
      : row 
      {
        : text
        { 
          label = "yyy:";
        }
        : text
        { 
          label = "";
          key = "";
        } 
      }    
  }

    //stvrti riadok dialogu - posudenie kapacity potrubia
  : boxed_row
  {
    label = "Posudenie kapacity potrubia";
    : column {   
      //vstupne hodnoty - prvy riadok
      : row 
      {
        : column
        {
          width = 20;
          : text 
          {  
            label = "xxx";
          }
          : edit_box
          {
            label = "";
            key = "";
            value = "";
          }
        }
        : column
        {
          width = 20;
          : text 
          {  
            label = "xxx";
          }
          : edit_box
          {
            label = "";
            key = "";
            value = "";
          }
        }
        : column
        {
          width = 20;
          : text 
          {  
            label = "xxx";
          }
          : edit_box
          {
            label = "";
            key = "";
            value = "";
          }
        }
      }
    }
  }

  //xxxxx
  : boxed_row {
    label = "xxx";
      //vystupne hodnoty
      : row 
      {
        : text
        { 
          label = "yyy:";
        }
        : text
        { 
          label = "";
          key = "";
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