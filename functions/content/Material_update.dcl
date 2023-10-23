//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -//
// Material_update.dcl
// (c) Copyright 2023 Tomecko Jakub
//
// Dialog pre funkciu Material_update.lsp 
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -//

Material_update //nazod dcl

: dialog
{
  //nazov dialogu
  label = "Update betonu";

  //prvy riadok
  : boxed_row
  {
    label = "Konstrukcie a ich betony";
    
    //stlpec z nazvom konstrukcie
    : column
    {
      width = 30;
      : text
      {
        label = "Nazov konstrukcie";
      }
      : edit_box
      {
        key = "konstrukcia01";
      }
      : edit_box
      {
        key = "konstrukcia02";
      }
      : edit_box
      {
        key = "konstrukcia03";
      }
      : edit_box
      {
        key = "konstrukcia04";
      }
      : edit_box
      {
        key = "konstrukcia05";
      }
      : edit_box
      {
        key = "konstrukcia06";
      }
      : edit_box
      {
        key = "konstrukcia07";
      }
      : edit_box
      {
        key = "konstrukcia08";
      }
      : edit_box
      {
        key = "konstrukcia09";
      }
      : edit_box
      {
        key = "konstrukcia10";
      }
    }

    //stlpec z betonom
    : column
    {
      width = 40;
      : text
      {
        label = "Popis betonu";
      }
      : edit_box
      {
        key = "beton01";
      }
      : edit_box
      {
        key = "beton02";
      }
      : edit_box
      {
        key = "beton03";
      }
      : edit_box
      {
        key = "beton04";
      }
      : edit_box
      {
        key = "beton05";
      }
      : edit_box
      {
        key = "beton06";
      }
      : edit_box
      {
        key = "beton07";
      }
      : edit_box
      {
        key = "beton08";
      }
      : edit_box
      {
        key = "beton09";
      }
      : edit_box
      {
        key = "beton10";
      }
    }

    //stlpec z oznacenim riadka
    : column
    {
      : text
      {
        label = "";
      }
      : toggle
      {
        key = "oznacit01";
        label = "Zapisat";
      }
      : toggle
      {
        key = "oznacit02";
        label = "Zapisat";
      }
      : toggle
      {
        key = "oznacit03";
        label = "Zapisat";
      }
      : toggle
      {
        key = "oznacit04";
        label = "Zapisat";
      }
      : toggle
      {
        key = "oznacit05";
        label = "Zapisat";
      }
      : toggle
      {
        key = "oznacit06";
        label = "Zapisat";
      }
      : toggle
      {
        key = "oznacit07";
        label = "Zapisat";
      }
      : toggle
      {
        key = "oznacit08";
        label = "Zapisat";
      }
      : toggle
      {
        key = "oznacit09";
        label = "Zapisat";
      }
      : toggle
      {
        key = "oznacit10";
        label = "Zapisat";
      }
    }

  }  

  //druhy riadok
  : boxed_row
  {
    label = "Nastavenia";
    : popup_list
    {  
      label = "Typ tabulky";
      key = "typTabulky";
      value = "0";
    }
    : edit_box
    {
      label = "Popis vystuze";
      key = "vystuz";
    }
  }

  //treti riadok
  : row
  {
    //tlacidlo oznacit vsetko
    : button
    {
      label = "Oznacit vsetko";
      key = "oznacitVsetko";
      width = 10;
    }  
    //tlacidlo odznacit vsetko
    : button
    {
      label = "Odznacit vsetko";
      key = "odznacitVsetko";
      width = 10;
    }
    //tlacidlo vymazat riadky
    : button
    {
      label = "Vymazat vsetko";
      key = "vymazatVsetko";
      width = 10;
    }
    //prepinac pre hranate rohy tabulky
    : toggle
    {
      label = "Hranate rohy tabulky";
      key = "hranataTabulka";
    }
  }

  //predposledny riadok
  : row
  {
    //poznamky
    : boxed_row
    {
    label = "Poznamka";
    : text
    {
      label = "Trieda ocele sa automaciky zapise ku kazdej konstrukcii.";
      width = 45;
    } 
    }
    //status riadok
    : boxed_row
    {
      label = "Status";
      : text
      {
        label = "Status";
        key = "status";
      }
    }
  }

  //posledny riadok
  : row
  {
    //tlacidlo napoveday
    : button
    {
      label = "Napoveda";
      key = "napoveda";
      mnemonic = "N";
    }
    //tlacidlo ulozit
    : button
    {
      label = "Ulozit";
      key = "ulozit";
      mnemonic = "U";
    }  
    //tlacidlo aktualizovat
    : button
    {
      label = "Aktualizovat";
      key = "aktualizovat";
      is_default = true;
      mnemonic = "A";
    }
    //tlacidlo zacriet
    : button
    {
      label = "Zavriet";
      key = "cancel";
      is_cancel = true;
      mnemonic = "Z";
    }    
  }
}

/////// DIALOGOVE OKNO NAPOVEDA ///////

NapovedaMaterial

: dialog
{
  label = "Napoveda o znaceni betonov";

  : row {
    //priklad oznacenie betonu
    : boxed_column
    {
      label = "Priklad oznacenie betonu";
      : text
      {
        label = "C30/37 - XC2, XF2(SK)-Cl 0,4-Dmax 16-S3";
      }
    }
    //Poznamka (*)
    : boxed_column
    {
      label = "Poznamka (*)";
      : text
      {
        label = "Relativna vlhkost vzduchu: * < 30% | ** 30% - 60% | *** 60% - 85% | ***** > 85%";
      }
    }
  }

  : row
  {
    //stlpec s betonmi podla STN 206
    : boxed_column
    {
      label = "Betony STN 206";
      : text { label = "C8/10"; alignment = centered;}
      : text { label = "C12/15"; alignment = centered;}
      : text { label = "C16/20"; alignment = centered;}
      : text { label = "C20/25"; alignment = centered;}
      : text { label = "C25/30"; alignment = centered;}
      : text { label = "C30/37"; alignment = centered;}
      : text { label = "C35/45"; alignment = centered;}
      : text { label = "C40/50"; alignment = centered;}
      : text { label = "C45/55"; alignment = centered;}
      : text { label = "C50/60"; alignment = centered;}
      : text { label = "C55/67"; alignment = centered;}
      : text { label = "C60/75"; alignment = centered;}
      : text { label = "C70/85"; alignment = centered;}
      : text { label = "C80/95"; alignment = centered;}
      : text { label = "C90/107"; alignment = centered;}
      : text { label = "C100/116"; alignment = centered;}
    }

    : boxed_column {
      label = "Stupne vplyvu prostrednia";

      //1. stupen
      : boxed_row
      {
        label = "1 - Bez nebezpecenstva korozie alebo porusenia";
      //prvy stlpec
      : column
        {
          width = 3;
          fixed_width = true;
          alignment = left;
          : text { label = "X0"; alignment = centered;}
        }
      //druhy stlpec
      : column
        {
          width = 5;
          fixed_width = true;
          alignment = left;
          : text { label = "Pre beton bez vystuze alebo kovovych prvkov"; alignment = centered;}
        }
      //treti stlpec
      : column
        {
          width = 95;
          fixed_width = true;
          : text { label = "Beton vnutri budov s velmi nizkou (*) vlhkostou vzduchu, beton zakladov bez vystuze (prostredie bez mrazu)"; }
        }  
      }

      //2. stupen
      : boxed_row
      {
        label = "2 - Korozia vystuze vplyvom karbonatacie";
      //prvy stlpec
      : column
        {
          width = 3;
          fixed_width = true;
          : text { label = "XC1"; alignment = centered;}
          : text { label = "XC2"; alignment = centered;}
          : text { label = "XC3"; alignment = centered;}
          : text { label = "XC4"; alignment = centered;}
        }
      //druhy stlpec
      : column
        {
          width = 5;
          fixed_width = true;
          : text { label = "Suche alebo stale mokre"; alignment = centered;}
          : text { label = "Mokre, obsacne suche"; alignment = centered;}
          : text { label = "Stredne mokre, vlhke"; alignment = centered;}
          : text { label = "Striedavo mokre a suche"; alignment = centered;}
        }
      //treti stlpec
      : column
        {
          width = 95;
          fixed_width = true;
          alignment = left;
          : text { label = "Beton vnutri budov s nizkou vlhkostou (**) vzduchu, beton trvale ponoreny vo vode"; }
          : text { label = "Povrch betonu vystaveny dlhodobemu posobeniu vody alebo vysokej (***) vlhkosti vzduchu"; }
          : text { label = "Beton vnutri budov so strednou (***) vlhkostou vzduchu, vonkajsi beton chraneny proti dazdu"; }
          : text { label = "Povrch betonov v styku s vodou, ktore nie su v XC2/XC3 (casti vystavene priamo zrazkam alebo vlhkosti)"; }
        }  
      }

      //3. stupen
      : boxed_row
      {
        label = "3 - Korozia vystuze vplyvom chloridov, nie vsak z morskej vody";
      //prvy stlpec
      : column
        {
          width = 3;
          fixed_width = true;
          : text { label = "XD1"; alignment = centered;}
          : text { label = "XD2"; alignment = centered;}
          : text { label = "XD3"; alignment = centered;}
        }
      //druhy stlpec
      : column
        {
          width = 15;
          fixed_width = true;
          alignment = left;
          : text { label = "Stredne mokre, vlhke"; alignment = centered;}
          : text { label = "Mokre, obsacne suche"; alignment = centered;}
          : text { label = "Striedavo mokre a suche"; alignment = centered;}
        }
      //treti stlpec
      : column
        {
          width = 95;
          fixed_width = true;
          alignment = left;
          : text { label = "Povrchy betonov vystavene chloridom rozplylenym vo vzoduchu (samostatne garaze)"; }
          : text { label = "Beton vystaveny posobeniu priemyselnych vod, ktore obsahuju chloridy(plavecke bazeny)"; }
          : text { label = ""; }
        }  
      }

      //4. stupen
      : boxed_row
      {
        label = "4 - Korozia vystuze vplyvom chloridov z morskej vody";
      //prvy stlpec
      : column
        {
          width = 3;
          fixed_width = true;
          : text { label = "XS1"; alignment = centered;}
          : text { label = "XS2"; alignment = centered;}
          : text { label = "XS3"; alignment = centered;}
        }
      //druhy stlpec
      : column
        {
          width = 15;
          fixed_width = true;
          alignment = left;
          : text { label = "Vystaveny slanemu vzduchu"; alignment = centered;}
          : text { label = "Trvalo ponoreny vo vode"; alignment = centered;}
          : text { label = "Zmacany a ostrekovany prilivom"; alignment = centered;}
        }
      //treti stlpec
      : column
        {
          width = 95;
          fixed_width = true;
          alignment = left;
          : text { label = "Stavby blizko morskeho pobrezia alebo na pobrezi"; }
          : text { label = "Casti stavieb v mori"; }
          : text { label = "Casti stavieb v mori"; }
        }  
      }

      //5. stupen
      : boxed_row
      {
        label = "5 - Striedave posobenie mrazu a rozmrazovania s rozmrazovacimi prostriedkami alebo bez nich";
      //prvy stlpec
      : column
        {
          width = 3;
          fixed_width = true;
          : text { label = "XF1"; alignment = centered;}
          : text { label = "XF2"; alignment = centered;}
          : text { label = "XF3"; alignment = centered;}
          : text { label = "XF4"; alignment = centered;}
        }
      //druhy stlpec
      : column
        {
          width = 15;
          fixed_width = true;
          alignment = left;
          : text { label = "Mierne nasyteny vodou bez rozm. prostriedkov"; alignment = centered;}
          : text { label = "Mierne nasyteny vodou s rozm. prostriedkami"; alignment = centered;}
          : text { label = "Znacne nasyteny vodou bez rozm. prostriedkov"; alignment = centered;}
          : text { label = "Znacne nasyteny vodou s rozm. prostriedkami"; alignment = centered;}
        }
      //treti stlpec
      : column
        {
          width = 95;
          fixed_width = true;
          alignment = left;
          : text { label = "Vonkajsie zvisle casti vystavene dazdu a mrazu (priecla budov, stlpy), nie prilis zmacane casti stavieb"; }
          : text { label = "Vonkajsie zvisle casti vystavene mrazu a rozmracovacim prostriedkom rozpylenym vo vzduchu (PHS, oporny mur)"; }
          : text { label = "Vonkajsie casti vystavene dazdu a mrazu, casto zmacane casti (otvorene nadrze na vodu)"; }
          : text { label = "Casti priamo vystavene rozmrazovacim prostriedkom a mrazu, blizkosti komunikacii vystavene priamemu postreku"; }
        }  
      }

      //6. stupen
      : boxed_row
      {
        label = "6 - Korozia betonu vplyvom chemickeho posobenia";
      //prvy stlpec
      : column
        {
          width = 3;
          fixed_width = true;
          : text { label = "XA1"; alignment = centered;}
          : text { label = "XA2"; alignment = centered;}
          : text { label = "XA3"; alignment = centered;}
        }
      //druhy stlpec
      : column
        {
          width = 15;
          fixed_width = true;
          alignment = left;
          : text { label = "Slabo agresivne chem. prostredia"; alignment = centered;}
          : text { label = "Stredne agresivne chem. prostredia"; alignment = centered;}
          : text { label = "Silno agresivne chem. prostredia"; alignment = centered;}
        }
      //treti stlpec
      : column
        {
          width = 95;
          fixed_width = true;
          alignment = left;
          : text { label = "Nadrze cistiarni odpadovych vod, zumpy, spetiky, zaklady stavieb"; alignment = left;}
          : text { label = "Casti stavieb v podach agresivnych voci betonu, zaklady stavieb"; }
          : text { label = "Premyselne cistiarne odpad. vod s chem. agresivnymi vodami, silazne jamy, chladiace veze"; }
        }  
      }
      
    }
  }

  : row {
    //obsah chloridov v betone
    : boxed_column
    {
      label = "Obsah chloridov v betone";
      : text
      {
        label = "Cl 1,0 - Beton bez ocelovej vystuze / kovovych prvkov, mimo zavesnych hakov odolnych proti korozii | Cl 0,4 - Beton s ocelovou vystuzou / kovovymi prvkami | Cl 0,1 - Beton s predpatou vystuzov";
      }
    }
  }




  : button
  {
    key = "zatvoritNapovedu";
    label = "OK";
    is_default = true;
    is_cancel = true;
    width = 15;
    fixed_width = true;
    alignment = centered;
  }
}