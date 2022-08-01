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
  
  // Zaciatok definicie textu
  : text
  {
    // Definovanie obsahu textoveho pola
    label = "To je test";
    // Zarovnanie textu
    alignment = centered;
  } // Koniec definicie textu

  // Zaciatok definovanie buttonu
  : button
  {
    // Kluc alebo nazov buttonu (referencia pre AutoLISP kod)
    key = "accept";
    // Definovanie obsahu buttonu
    label = "Close";
    // Definovanie prednastaveneho stavu (automaticke oznacenie po stlaceni entra
    is_default = true;
    // Vynutenie, aby button bol dostatocne velky pre text
    fixed_width = true;
    // Zarovanie buttonu
    alignment = centered;
  } // Koniec definovnaie buttonu
} // Koniec definovanie dialogoveho okna

//----------------------------------------------------------------------//
//                             End of File                              //
//----------------------------------------------------------------------//