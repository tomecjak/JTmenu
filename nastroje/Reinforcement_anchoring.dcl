//=========================================================================
// Reinforcement_anchoring.dcl
// (c) Copyright 2022 Tomecko Jakub
// Verzia: 0.9 beta
//
// UI okno pre funkciu Reinforcement_anchoring.lsp
//-------------------------------------------------------------------------

// Nazov dialogoveho okna
Reinforcement_anchoring

// Zaciatok definicie dialogoveho okna
: dialog
{
  // Nazov dialogoveho okna zobrazeneho v hornom bare
  label = "Reinforcement anchoring and overlap";

  : row
  {
    // Definicie boxed collum
    : boxed_column 
    {
      // Definovanie nazvu boxed collum
      label = "Vstupne hodnoty";
        // Definicia popup listu - trieda betonu
        : popup_list
        {
          // Nazov popup listu
          key = "ConcreteSelections";
          value = "4";
        }

        // Definicia popup listu - parcialny sucinitel
        : popup_list
        {
          // Nazov popup listu
          key = "ParcialSelections";
          value = "1";
        }
    }
  }

  // Zaciatok definovanie buttonu vypocitat
  : button
  {
    // Kluc alebo nazov buttonu (referencia pre AutoLISP kod)
    key = "count";
    // Definovanie obsahu buttonu
    label = "Vypocitat";
    // Definovanie prednastaveneho stavu (automaticke oznacenie po stlaceni entra
    is_default = true;
    // Vynutenie, aby button bol dostatocne velky pre text
    fixed_width = true;
    // Zarovanie buttonu
    alignment = centered;
  }

  // Predinovanie OK/Cancel
  cancel_button;
  
  
} // Koniec definovanie dialogoveho okna

//----------------------------------------------------------------------//
//                             End of File                              //
//----------------------------------------------------------------------//

//////////////////////////////////////////////////////////////////////////