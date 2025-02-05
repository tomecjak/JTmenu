//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -//
// Hydrotechnical_calculation.dcl
// (c) Copyright 2025 Tomecko Jakub
//
// Dialog pre funkciu Hydrotechnical_calculation.lsp 
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -//

Hydrotechnical_calculation //nazov dcl

: dialog
{
  //nazov dialogu
  label = "Hydrotechnicky vypocet";

  
}

//vstupne hodnoty:
//hodnoty prietoku Qx
//vyska na začiatku toku - h1
//vyska na konci toku - h2
//vzdialenost medzi bodmi - L
//stupen drsnosti koryta - n
//prietocna plocha - S - cislo alebo vyber polyliny
//omoceny obvod - O - cislo alebo vyber polyliny

//vystupne hodnoty:
//vyskovy rozidel - delta
//vypocitany sklon - io
//hydrailický polomer - R
//rychlostny sucinitel - C
//prietokove mnozstvo - Q

//tlacidla:
//napoveda
//report
//vypocitaj
//zavriet
