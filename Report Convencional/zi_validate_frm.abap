FORM validate_fields.

* CARRID - SCARR
  IF p_carrid IS NOT INITIAL.
    SELECT SINGLE carrid
      FROM scarr
      WHERE carrid = @p_carrid
      INTO @DATA(lv_carrid).

    IF sy-subrc <> 0.
      MESSAGE 'CARRID não encontrado na SCARR' TYPE 'E'.
    ENDIF.
  ENDIF.

* CONNID - SPFLI (dependente)
  IF p_connid IS NOT INITIAL.
    SELECT SINGLE connid
      FROM spfli
      WHERE connid = @p_connid
        AND ( carrid = @p_carrid OR @p_carrid IS INITIAL )
      INTO @DATA(lv_connid).

    IF sy-subrc <> 0.
      MESSAGE 'CONNID inválido para o CARRID informado' TYPE 'E'.
    ENDIF.
  ENDIF.

* CITYFROM
  IF p_cityfr IS NOT INITIAL.
    SELECT SINGLE city
      FROM sgeocity
      WHERE city = @p_cityfr
      INTO @DATA(lv_cityfr).

    IF sy-subrc <> 0.
      MESSAGE 'Cidade de origem não encontrada' TYPE 'E'.
    ENDIF.
  ENDIF.

* CITYTO
  IF p_cityto IS NOT INITIAL.
    SELECT SINGLE city
      FROM sgeocity
      WHERE city = @p_cityto
      INTO @DATA(lv_cityto).

    IF sy-subrc <> 0.
      MESSAGE 'Cidade de destino não encontrada' TYPE 'E'.
    ENDIF.
  ENDIF.

ENDFORM.


FORM get_data.

  CLEAR gt_spfli.

  SELECT *
    FROM spfli
    WHERE ( carrid   = @p_carrid OR @p_carrid IS INITIAL )
      AND ( connid   = @p_connid OR @p_connid IS INITIAL )
      AND ( cityfrom = @p_cityfr OR @p_cityfr IS INITIAL )
      AND ( cityto   = @p_cityto OR @p_cityto IS INITIAL )
    INTO TABLE @gt_spfli.

  IF sy-subrc <> 0.
    MESSAGE 'Nenhum dado encontrado' TYPE 'I'.
  ENDIF.

ENDFORM.


FORM display_alv.

  DATA: lo_alv TYPE REF TO cl_salv_table.

  TRY.
      cl_salv_table=>factory(
        IMPORTING
          r_salv_table = lo_alv
        CHANGING
          t_table      = gt_spfli ).

      lo_alv->display( ).

    CATCH cx_salv_msg INTO DATA(lx_msg).
      MESSAGE lx_msg->get_text( ) TYPE 'E'.
  ENDTRY.

ENDFORM.