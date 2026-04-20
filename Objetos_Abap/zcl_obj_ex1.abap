class ZCL_OBJ_EX1 definition
  public
  final
  create public .

public section.

  types:
    CTY_SPFLI_TAB type STANDARD TABLE OF SPFLI WITH EMPTY KEY .

  methods VALIDATE_FIELD
    importing
      !IM_CARRID type SCARR-CARRID
      !IM_CONNID type SPFLI-CONNID
      !IM_CITYTO type SPFLI-CITYTO
      !IM_CITYFR type SPFLI-CITYFROM .
  methods GET_DATA
    importing
      !IM_CARRID type SCARR-CARRID
      !IM_CONNID type SPFLI-CONNID
      !IM_CITYTO type SPFLI-CITYTO
      !IM_CITYFR type SPFLI-CITYFROM
    exporting
      !EX_RESULT type CTY_SPFLI_TAB .
  methods DISPLAY
    changing
      !CH_RESULT type CTY_SPFLI_TAB .
protected section.
private section.
ENDCLASS.



CLASS ZCL_OBJ_EX1 IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_OBJ_EX1->DISPLAY
* +-------------------------------------------------------------------------------------------------+
* | [<-->] CH_RESULT                      TYPE        CTY_SPFLI_TAB
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD display.


    cl_salv_table=>factory(
      IMPORTING
        r_salv_table   = DATA(lo_salv)                          " Basis Class Simple ALV Tables
      CHANGING
        t_table        = ch_result
    ).

    lo_salv->display( ).

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_OBJ_EX1->GET_DATA
* +-------------------------------------------------------------------------------------------------+
* | [--->] IM_CARRID                      TYPE        SCARR-CARRID
* | [--->] IM_CONNID                      TYPE        SPFLI-CONNID
* | [--->] IM_CITYTO                      TYPE        SPFLI-CITYTO
* | [--->] IM_CITYFR                      TYPE        SPFLI-CITYFROM
* | [<---] EX_RESULT                      TYPE        CTY_SPFLI_TAB
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_data.

    CLEAR ex_result.

    SELECT *
      FROM spfli
      WHERE carrid   EQ @im_carrid
        AND connid   EQ @im_connid
        AND cityfrom EQ @im_cityfr
        AND cityto   EQ @im_cityto
      INTO TABLE @ex_result.

    IF sy-subrc <> 0.
      MESSAGE 'Nenhum dado encontrado' TYPE 'E'.
    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_OBJ_EX1->VALIDATE_FIELD
* +-------------------------------------------------------------------------------------------------+
* | [--->] IM_CARRID                      TYPE        SCARR-CARRID
* | [--->] IM_CONNID                      TYPE        SPFLI-CONNID
* | [--->] IM_CITYTO                      TYPE        SPFLI-CITYTO
* | [--->] IM_CITYFR                      TYPE        SPFLI-CITYFROM
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD VALIDATE_FIELD.

    IF im_carrid IS NOT INITIAL.
      SELECT SINGLE carrid
        FROM scarr
        WHERE carrid = @im_carrid
        INTO @DATA(lv_carrid).

      IF sy-subrc <> 0.
        MESSAGE 'CARRID não encontrado na SCARR' TYPE 'E'.
      ENDIF.
    ENDIF.

* CONNID - SPFLI (dependente)
    IF im_connid IS NOT INITIAL.
      SELECT SINGLE connid
        FROM spfli
        WHERE connid = @im_connid
          AND ( carrid = @im_carrid OR @im_carrid IS INITIAL )
        INTO @DATA(lv_connid).

      IF sy-subrc <> 0.
        MESSAGE 'CONNID inválido para o CARRID informado' TYPE 'E'.
      ENDIF.
    ENDIF.

* CITYFROM
    IF im_cityfr IS NOT INITIAL.
      SELECT SINGLE city
        FROM sgeocity
        WHERE city = @im_cityfr
        INTO @DATA(lv_cityfr).

      IF sy-subrc <> 0.
        MESSAGE 'Cidade de origem não encontrada' TYPE 'E'.
      ENDIF.
    ENDIF.

* CITYTO
    IF im_cityto IS NOT INITIAL.
      SELECT SINGLE city
        FROM sgeocity
        WHERE city = @im_cityto
        INTO @DATA(lv_cityto).

      IF sy-subrc <> 0.
        MESSAGE 'Cidade de destino não encontrada' TYPE 'E'.
      ENDIF.
    ENDIF.

  ENDMETHOD.
ENDCLASS.