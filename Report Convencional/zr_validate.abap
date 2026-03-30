REPORT ZR_VALIDATE.

INCLUDE zi_validate_top.
INCLUDE zi_validate_scr.
INCLUDE zi_validate_frm.

START-OF-SELECTION.

  PERFORM validate_fields.
  PERFORM get_data.
  PERFORM display_alv.