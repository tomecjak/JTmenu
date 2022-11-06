//hotimage
hotimg

: image_button
{
  color=0;
  height=4;
  aspect_ratio=1.5;
  allow_accept=true;
  fixed_height=true;
  fixed_width=true;
}

//library
lib

: dialog
{
  key="capt";
  initial_focus="lb";
  
    //prvy riadok
    : row
    {
      //prvy stlpec s polozkami
      : column
      {
        alignment=top;
        fixed_height=true;
        
        //nazov listu poloziek
        : text
        {
          key="TX1";
          label="Polozky:";
        }
        
        //medzera
        : spacer
        {
          width=1;
        }
        
        //zoznanam poloziek
        : list_box
        {
          width=20;
          height=19;
          fixed_height=true;
          key="lb";
          allow_accept=true;
        }
        
        //medzera
        : spacer
        {
          width=1;
        }
        
        //checkbox
        : toggle
        {
          label="Rozlozit";
          key="tgExp";
        }

        //nastavenie mierky
        : edit_box
        { 
          label = "Mierka 1:";
          key = "blockScale";
          value = "50";
        }
      }
      
      //druhy stlpec s obrazkami
      : column
      { 
        //popup list skupin
        : popup_list
        {
          label="Typ dopravneho znacenia:";
          key="cb";
        }
        
        //prvy riadok nahladov
        : row
        {
          : hotimg
          {
            key="0";
          }
          : hotimg
          {
            key="1";
          }
          : hotimg
          {
            key="2";
          }
          : hotimg
          {
            key="3";
          }
        }
        
        //druhy riadok nahladov
        : row
        {
          : hotimg
          {
            key="4";
          }
          : hotimg
          {
            key="5";
          }
          : hotimg
          {
            key="6";
          }: hotimg
          {
            key="7";
          }
        }
        
        //treti riadok nahladov
        : row
        {
          : hotimg
          {
            key="8";
          }
          : hotimg
          {
            key="9";
          }
          : hotimg
          {
            key="10";
          }
          : hotimg
          {
            key="11";
          }
        }
        
        //stvrty riadok nahladov
        : row
        {
          : hotimg
          {
            key="12";
          }
          : hotimg
          {
            key="13";
          }
          : hotimg
          {
            key="14";
          }
          : hotimg
          {
            key="15";
          }
        }
        
        //piaty riadok nahladov
        : row
        {
          : hotimg
          {
            key="16";
          }
          : hotimg
          {
            key="17";
          }
          : hotimg
          {
            key="18";
          }
          : hotimg
          {
            key="19";
          }
        }
      }
    }
    
    //druhy riadok
    : row
    {
      fixed_width=true;
      alignment=centered;
      
      //tlacidlo spat
      : button
      {
        label="< Spat";
        key="btPrev";
      }
      
      //tlacidlo dalej
      : button
      {
        label="Dalsie >";
        key="btNext";
      }
      
      //medzera
      : spacer
      {
        width=1;
      }
      
      //tlacidlo OK
      : button
      {
        label="    OK    ";
        key="btOk";
        is_default=true;
      }
      
      //tlacidlo Storno
      : button
      {
        label="Storno";
        key="btCan";
        is_cancel=true;
      }
    }
    
  errtile; 
}
