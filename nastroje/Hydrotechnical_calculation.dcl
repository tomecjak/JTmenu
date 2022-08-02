//=========================================================================
// Hydrotechnical_calculation.dcl
// (c) Copyright 2022 Tomecko Jakub
// Verzia: 0.9 beta
//
// UI okno pre funkciu Hydrotechnical_calculation.lsp
//-------------------------------------------------------------------------

//---------------------------------------------------------------------------------------------------------
// Hydrotechnical_calculation
//---------------------------------------------------------------------------------------------------------
Hydrotechnical_calculation : dialog {
  key = "Title";
  label = "";//Title$ from lsp file
  spacer;
  : row {
    : column {
      fixed_width = true;
      : row {
        : column {
          spacer;
          : image_button {
            key = "select_pick";
            width = 3.59;
            height = 1.66;
            fixed_width = true;
            fixed_height = true;
            aspect_ratio = 1;
            color = -15;
          }
          spacer;
        }
        : column {
          spacer;
          : text {
            key = "Prompt";
            label = "";
            width = 31.09;
            fixed_width = true;
            vertical_margin = none;
          }
          spacer;
        }
      }
    }
  }
  : boxed_column {
    label = "Object Information";
    width = 34.26;
    fixed_width = true;
    : paragraph {
      : text_part {
        key = "Text1";
        label = "";//Text1$ from lsp file
      }
      : text_part {
        key = "Text2";
        label = "";//Text2$ from lsp file
      }
      : text_part {
        key = "Text3";
        label = "";//Text3$ from lsp file
      }
    }
    spacer;
  }
  spacer;
  ok_only;
}//MyPickButton

//----------------------------------------------------------------------//
//                             End of File                              //
//----------------------------------------------------------------------//