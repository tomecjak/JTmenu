bx_confirm : dialog {
  label = "Hromadné spracovanie DWG";

  : column {
    : text {
      key   = "msg";
      label = " ";
    }

    : row {
      : button {
        key        = "ok";
        label      = "Pokračovať";
        is_default = true;
      }
      : button {
        key       = "cancel";
        label     = "Zrušiť";
        is_cancel = true;
      }
    }
  }
}