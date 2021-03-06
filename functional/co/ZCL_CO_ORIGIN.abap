CLASS zcl_co_origin DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-METHODS:
      validate_origin
        IMPORTING !iv_hrkft TYPE hrkft
        RAISING   cx_no_entry_in_table.

  PROTECTED SECTION.
  PRIVATE SECTION.

    TYPES tt_origins TYPE HASHED TABLE OF hrkft WITH UNIQUE KEY primary_key COMPONENTS table_line.

    CONSTANTS: BEGIN OF c_tabname,
                 origin TYPE tabname VALUE 'TKKH1',
               END OF c_tabname.

    CLASS-DATA gt_origins TYPE tt_origins.

    CLASS-METHODS:
      read_origins_lazy.

ENDCLASS.



CLASS zcl_co_origin IMPLEMENTATION.

  METHOD read_origins_lazy.
    CHECK gt_origins IS INITIAL.
    SELECT DISTINCT hrkft FROM tkkh1 INTO TABLE @gt_origins.
  ENDMETHOD.

  METHOD validate_origin.

    read_origins_lazy( ).

    IF NOT line_exists( gt_origins[ KEY primary_key COMPONENTS table_line = iv_hrkft ] ).
      RAISE EXCEPTION TYPE cx_no_entry_in_table
        EXPORTING
          table_name = CONV #( c_tabname-origin )
          entry_name = CONV #( iv_hrkft ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.