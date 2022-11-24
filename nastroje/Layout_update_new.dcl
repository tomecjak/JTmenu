Layout_update //nazov dcl

: dialog
{
  //nazov dialogu
  label = "Layout nastavenia new";  

  //prvy riadok - telo rozpisky
  : boxed_column
  {
    label = "Rozpiska";

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
              key = "xxZodp. projektant";
              width = 20;
            }
          }
          : column
          {
            : edit_box
            {
              key = "xxHl. inz. projektu";
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
              key = "xxKontroloval";
              width = 30;
            }
          }
          : column
          {
            : edit_box
            {
              key = "xxOkres stavby";
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
              key = "xxObjednavatel";
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
            label = "Cislo objektu";
            width = 40;
          }
        }
        //druhy riadok - vyhotovil
        : row
        {
          : toggle
          {
            key = "vykresVypracovalAktualizacia";
            label = "Aktualizovat vyhotovela";
            width = 40;
          }
        }
        //treti riadok - Uppercase nazov zakazky
        : row
        {
          : toggle
          {
            key = "zakazkaNazovUppercase";
            label = "Uppercase nazov zakazky";
            width = 40;
          }
        }
        //stvrti riadok - Uppercase nazov vykresu
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
            key = "xxNazov zakazky";
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
            key = "xxNazov objektu";
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
            }
          }
          : column
          {
            : toggle
            {
              key = "cisloVykresu";
              label = "Aktualizovat";
              width = 30;
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
              label = "Stupen";
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
              key = "xxStupen";
              width = 20;
            }
          }
          //druhy stlpec
          : column
          {
            : edit_box
            {
              key = "xxArchivne cislo";
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
              key = "xxDatum";
              width = 20;
            }
          }
          //druhy stlpec
          : column
          {
            : edit_box
            {
              key = "xxCZakzky";
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
              label = "Mierka";
              width = 20;
            }
          }
          //druhy stlpec
          : column
          {
            : text
            {
              label = "Format";
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
        label = "Pocet cislic:";
        key = "formatCislovania";
        value = "0";
      }
    }

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
  }

  //treti riadok dialogu s ukazkou formatovania nazvu suboru
  : boxed_column
  {
    label = "Priklady naformatovania nazvu suboru";

    : text
    {
      label = "2xx-xx_xx_Nazov vykresu / 2xx-xx_xxx_Nazov vykresu     Poznamka: Namiesto znaku podtrznika moze byt aj medzera.";
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
    }

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

