Layout_update //nazov dcl

: dialog
{
  //nazov dialogu
  label = "Rozpiska update";  

  //prvy riadok - telo rozpisky
  : boxed_column
  {
    label = "Udaje rozpisky";

    //prvy riadok rozpisky - mena, investor a podobne
    : row
    {
      //prvy stlpec - deleni na 3/2/1 stlpce 
      : column
      {
        //prvy riadok - nazvy vstupov (3 stlpce)
        : row
        {
          : column
          {
            : text
            {
              label = "Vypracoval";
              width = 20;
            }
          }
          : column
          {
            : text
            {
              label = "Zodp. projektant";
              width = 20;
            }
          }
          : column
          {
            : text
            {
              label = "Hl. inz. projektu";
              width = 20;
            }
          }
        }

        //druhy riadok - vstupy (3 stlpce)
        : row
        {
          : column
          {
            : edit_box
            {
              key = "vykresVypracoval";
              width = 20;
            }
          }
          : column
          {
            : edit_box
            {
              key = "vykresZodpovednyProjektant";
              width = 20;
            }
          }
          : column
          {
            : edit_box
            {
              key = "vykresHlavnyInzinierProjektu";
              width = 20;
            }
          }
        }

        //treti riadok - nazvy vstupov (2 stlpce)
        : row
        {
          : column
          {
            : text
            {
              label = "Kontroloval";
              width = 30;
            }
          }
          : column
          {
            : text
            {
              label = "Okres stavby";
              width = 30;
            }
          }
        }

        //stvrti riadok - vtupy (2 stlpce)
        : row
        {
          : column
          {
            : edit_box
            {
              key = "vykresKontroloval";
              width = 30;
            }
          }
          : column
          {
            : edit_box
            {
              key = "vykresOkresStavby";
              width = 30;
            }
          }
        }

        //piaty riadok - nazvy vstupov (1 stlpce)
        : row
        {
          : column
          {
            : text
            {
              label = "Objednavatel";
              width = 60;
            }
          }
        }

        //siesti riadok - vtupy (1 stlpce)
        : row
        {
          : column
          {
            : edit_box
            {
              key = "vykresObjednavatel";
              width = 60;
            }
          }
        }
      }

      //druhy stlpec
      : column
      {
        //prvy riadok - cislo objektu
        : row
        {
          : toggle
          {
            key = "cisloObjektu";
            label = "Aktualizovat cislo objektu";
            width = 40;
            value = "1";
          }
        }
        //druhy riadok - vyhotovil
        : row
        {
          : toggle
          {
            key = "vykresVypracovalAktualizacia";
            label = "Aktualizovat kolonku vypracoval";
            width = 40;
            value = "1";
          }
        }
        //treti riadok - Uppercase nazov zakazky
        : row
        {
          : toggle
          {
            key = "vykresExterneDataAktualizovat";
            label = "Aktualizovat externe data";
            width = 40;
            value = "1";
          }
        }
        //stvrty riadok - Uppercase nazov zakazky
        : row
        {
          : toggle
          {
            key = "zakazkaNazovUppercase";
            label = "Uppercase nazov zakazky";
            width = 40;
          }
        }
        //piaty riadok - Uppercase nazov vykresu
        : row
        {
          : toggle
          {
            key = "vykresNazovUppercase";
            label = "Uppercase nazov vykresu";
            value = "1";
            width = 40;
          }
        }
      }
    }

    //druhy riadok - nazov zakazky/objektu, info o vykrese
    : row
    {
      //prvy stlpec s dvomi riadkami
      : column
      {
        //prvy riadok - nazov vstupu
        : row
        {
          : text
          {
            label = "Nazov zakazky";
            width = 64;
          }
        }

        //druhy riadok - vstup
        : row
        {
          : edit_box
          {
            key = "vykresNazovZakazky";
            width = 64;
          }  
        }

        //treti riadok - nazov vstupu
        : row
        {
          : text
          {
            label = "Nazov objektu";
            width = 64;
          }
        }

        //stvrty riadok - vstup
        : row
        {
          : edit_box
          {
            key = "vykresNazovObjektu";
            width = 64;
          }  
        }

        //stvrty a piaty prazdny riadok
        : row
        {
          : column
          {
            : text
            {
              label = "Nazov vykresu";
              width = 30;
            }
          }
          : column
          {
            : text
            {
              label = "Cislo vykresu";
              width = 30;
            }
          }
        }
        : row
        {
          : column
          {
            : toggle
            {
              key = "nazovVykresu";
              label = "Aktualizovat";
              width = 30;
              value = "1";
            }
          }
          : column
          {
            : toggle
            {
              key = "cisloVykresu";
              label = "Aktualizovat";
              width = 30;
              value = "1";
            } 
          }
        }
      }

      //druhy stlpec s troma riadkami a 2 stlpacami
      : column
      {
        //prvy riadok - nazov vstupov
        : row
        {
          //prvy stlpec
          : column
          {
            : text
            {
              label = "Stupen dokumentacie";
              width = 20;
            }
          }
          //druhy stlpec
          : column
          {
            : text
            {
              label = "Archivne cislo";
              width = 20;
            }
          }
        }

        //prvy riadok - vstupy
        : row
        {
          //prvy stlpec
          : column
          {
            : edit_box
            {
              key = "vykresStupenDokumentacie";
              width = 20;
            }
          }
          //druhy stlpec
          : column
          {
            : edit_box
            {
              key = "vykresArchivneCislo";
              width = 20;
            }
          }
        }

        //treti riadok - nazov vstupov
        : row
        {
          //prvy stlpec
          : column
          {
            : text
            {
              label = "Datum";
              width = 20;
            }
          }
          //druhy stlpec
          : column
          {
            : text
            {
              label = "Cislo zakazky";
              width = 20;
            }
          }
        }

        //stvrty riadok - vstupy
        : row
        {
          //prvy stlpec
          : column
          {
            : edit_box
            {
              key = "vykresDatum";
              width = 20;
            }
          }
          //druhy stlpec
          : column
          {
            : edit_box
            {
              key = "vykresCisloZakzky";
              width = 20;
            }
          }
        }

        //piati riadok - nazov vstupov
        : row
        {
          //prvy stlpec
          : column
          {
            : text
            {
              label = "Mierka pohladov";
              width = 20;
            }
          }
          //druhy stlpec
          : column
          {
            : text
            {
              label = "Format vykresu";
              width = 20;
            }
          }
        }

        //siesti riadok - vstupy
        : row
        {
          //prvy stlpec
          : column
          {
            : toggle
            {
              key = "mierkaVykresu";
              label = "Aktualizovat";
              width = 20;
              value = "1";
            }
          }
          //druhy stlpec
          : column
          {
            : toggle
            {
              key = "velkostVykresu";
              label = "Aktualizovat";
              width = 20;
              value = "1";
            }
          }
        }
      }
    }
  }

  //druhi riadok - nastavenie formatovanie cislovanie vykresu
  : row {
    : boxed_column
    {
      label = "Format cislovania vykresu";

      //nastavenie popup-listu
      : popup_list
      {
        label = "Format cislovania vykresu:";
        key = "formatCislovania";
        value = "0";
        width = 10;
      }
    }

    : boxed_column
    {
      label = "Premenovat tab layoutu";

      //checkbox - aktualizacia vyhotovitela
      : toggle
      {
        key = "layoutRename";
        label = "Ano";
        width = 30;
      }
    }
    : boxed_column
    {
      label = "Status";

      //text pre oznamovaciu hlasku
      : text
      {
        label = "";
        key = "oznamovaciaHlaska";
        width = 40;
      }
    }
  }

  //treti riadok dialogu s ukazkou formatovania nazvu suboru
  : boxed_column
  {
    label = "Priklady naformatovania nazvu suboru";

    : text
    {
      label = "201-00_01_Nazov vykresu / 202-00_001_Nazov vykresu  |  Poznamka: Namiesto znaku podtrznika moze byt pouzita aj medzera.";
    }
  }

  //treti riadok - tlacidla
  : row
  {
    //tlacidlo oznacit vsetko
    : button
    {
      key = "oznacitVsetko";
      label = "Oznacit vsetko";
    }  

    //tlacidlo odznacit vsetko
    : button
    {
      key = "odznacitVsetko";
      label = "Odznacit vsetko";
    }

    //tlacidlo ulozit
    : button
    {
      key = "ulozitUdajeRozpisky";
      label = "Ulozit";
      mnemonic = "U";
    }

    //tlacidlo aktualizovat
    : button
    {
      key = "aktualizovat";
      label = "Aktualizovat";
      is_default = true;
      mnemonic = "A";
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

