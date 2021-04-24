CLASS zcl_bc_mail_facade DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
      BEGIN OF t_attachment_bin,
        att_type    TYPE soodk-objtp,
        att_subject TYPE sood-objdes,
        att_content TYPE solix_tab,
      END OF t_attachment_bin .
    TYPES t_rlist TYPE zbcs_rec_list .
    TYPES tt_rlist TYPE zbctt_rec_list .
    TYPES:
      BEGIN OF t_dlist,
        dname TYPE so_obj_nam,
      END OF t_dlist .
    TYPES:
      tt_dlist TYPE STANDARD TABLE OF t_dlist WITH DEFAULT KEY .
    TYPES:
      BEGIN OF t_attachment_spool,
        att_subject TYPE sood-objdes,
        spoolid     TYPE rspoid,
        partnum     TYPE adsnum,
      END OF t_attachment_spool .
    TYPES:
      BEGIN OF t_attachment_txt,
        att_type    TYPE soodk-objtp,
        att_subject TYPE sood-objdes,
        att_content TYPE soli_tab,
      END OF t_attachment_txt .
    TYPES:
      tt_attachment_bin   TYPE STANDARD TABLE OF t_attachment_bin WITH DEFAULT KEY .
    TYPES:
      tt_attachment_spool TYPE STANDARD TABLE OF t_attachment_spool WITH DEFAULT KEY .
    TYPES:
      tt_attachment_txt   TYPE STANDARD TABLE OF t_attachment_txt WITH DEFAULT KEY .
    TYPES:
      BEGIN OF t_excel_attachment,
        itab_ref        TYPE REF TO data,
        columns         TYPE zsdtt_column,
        exclude_columns TYPE zsdtt_column,
        filename        TYPE sood-objdes,
      END OF t_excel_attachment .
    TYPES:
      tt_excel_attachment TYPE STANDARD TABLE OF t_excel_attachment WITH DEFAULT KEY .

    CONSTANTS:
      c_int(3)          TYPE c VALUE 'INT' ##NO_TEXT ##NEEDED.
    CONSTANTS:
      c_doc_type_htm(3) TYPE c VALUE 'HTM' ##NO_TEXT ##NEEDED.
    CONSTANTS c_rec_type TYPE c VALUE 'U' ##NO_TEXT ##NEEDED.
    CONSTANTS c_express TYPE c VALUE 'X' ##NO_TEXT.

    CLASS-METHODS cleanse_email_address
      IMPORTING
        !iv_address       TYPE ad_smtpadr
      RETURNING
        VALUE(rv_address) TYPE ad_smtpadr .
    CLASS-METHODS conv_symsg_to_body
      IMPORTING
        !is_symsg      TYPE symsg OPTIONAL
      RETURNING
        VALUE(rt_body) TYPE bcsy_text .
    CLASS-METHODS get_email_of_user
      IMPORTING
        !iv_uname       TYPE syuname
        !iv_check       TYPE flag DEFAULT abap_true
      RETURNING
        VALUE(rv_email) TYPE adr6-smtp_addr
      RAISING
        zcx_bc_user_master_data .
    CLASS-METHODS get_excel_columns_of_fcat
      IMPORTING
        !it_fcat      TYPE slis_t_fieldcat_alv
      RETURNING
        VALUE(rt_col) TYPE zsdtt_column .
    CLASS-METHODS get_excel_columns_of_table
      IMPORTING
        !iv_tabname   TYPE tabname
      RETURNING
        VALUE(rt_col) TYPE zsdtt_column .
    CLASS-METHODS get_user_of_email
      IMPORTING
        !iv_smtp        TYPE t024-smtp_addr
      RETURNING
        VALUE(rv_bname) TYPE usr21-bname
      RAISING
        zcx_bc_user_master_data .
    CLASS-METHODS send_email
      IMPORTING
        !iv_from             TYPE syuname DEFAULT sy-uname
        !it_to               TYPE rke_userid OPTIONAL
        !it_rlist            TYPE tt_rlist OPTIONAL
        !it_dlist            TYPE tt_dlist OPTIONAL
        !iv_subject          TYPE so_obj_des
        !iv_tolerate_no_addr TYPE abap_bool DEFAULT abap_false
        !it_body             TYPE bcsy_text
        !it_body_html        TYPE bcsy_text OPTIONAL
        !it_att_bin          TYPE tt_attachment_bin OPTIONAL
        !it_att_txt          TYPE tt_attachment_txt OPTIONAL
        !it_att_spool        TYPE tt_attachment_spool OPTIONAL
        !iv_requested_status TYPE bcs_rqst DEFAULT 'E'
        !iv_commit           TYPE char1 DEFAULT 'X'
        !iv_long_subject     TYPE string OPTIONAL
        !iv_sensitivity      TYPE so_obj_sns OPTIONAL
        !iv_sender           TYPE adr6-smtp_addr OPTIONAL
      RAISING
        zcx_bc_mail_send .
    CLASS-METHODS send_email_with_sap_link
      IMPORTING
        !it_to               TYPE rke_userid OPTIONAL
        !it_dlist            TYPE tt_dlist OPTIONAL
        !iv_subject          TYPE so_obj_des
        !iv_tolerate_no_addr TYPE abap_bool DEFAULT abap_false
        !it_body             TYPE bcsy_text
        !iv_command          TYPE clike
        VALUE(iv_commit)     TYPE char1 DEFAULT 'X'
        !iv_login_user       TYPE syuname OPTIONAL
      RAISING
        zcx_bc_mail_send .
    CLASS-METHODS send_excel_table_email
      IMPORTING
        !t_data             TYPE ANY TABLE OPTIONAL
        !t_columns          TYPE zsdtt_column OPTIONAL
        !iv_subject         TYPE so_obj_des
        !iv_long_subject    TYPE string OPTIONAL
        !it_body            TYPE bcsy_text
        !it_to              TYPE rke_userid OPTIONAL
        !iv_filename        TYPE sood-objdes
        !it_rlist           TYPE tt_rlist OPTIONAL
        !it_dlist           TYPE tt_dlist OPTIONAL
        !it_exclude_columns TYPE zsdtt_column OPTIONAL
        !iv_commit          TYPE abap_bool DEFAULT abap_true
      RAISING
        zcx_bc_mail_send .

    CLASS-METHODS send_excel_tables_email
      IMPORTING
        !iv_subject      TYPE so_obj_des
        !iv_long_subject TYPE string OPTIONAL
        !it_body         TYPE bcsy_text
        !it_excel_att    TYPE tt_excel_attachment
        !it_to           TYPE rke_userid OPTIONAL
        !it_rlist        TYPE tt_rlist OPTIONAL
        !it_dlist        TYPE tt_dlist OPTIONAL
        !iv_commit       TYPE abap_bool DEFAULT abap_true

      RAISING
        zcx_bc_mail_send .
    CLASS-METHODS send_html_table_email
      IMPORTING
        !t_data          TYPE ANY TABLE OPTIONAL
        !t_rcvlist       TYPE zsdtt_mail_receiver OPTIONAL
        !t_columns       TYPE zsdtt_column OPTIONAL
        !iv_so10_object  TYPE tdobname OPTIONAL
        !iv_subject      TYPE so_obj_des OPTIONAL
        !iv_long_subject TYPE string OPTIONAL
        !t_body          TYPE tlinet OPTIONAL
        !it_dlist        TYPE tt_dlist OPTIONAL
      RAISING
        zcx_bc_mail_send .
    CLASS-METHODS send_symsg_as_email
      IMPORTING
        !iv_from    TYPE syuname DEFAULT sy-uname
        !it_to      TYPE rke_userid
        !iv_subject TYPE so_obj_des
        !is_symsg   TYPE symsg OPTIONAL
      RAISING
        zcx_bc_mail_send .

    CLASS-METHODS validate_email_address
      IMPORTING !email TYPE ad_smtpadr
      RAISING   zcx_bc_email_address.

  PROTECTED SECTION.
  PRIVATE SECTION.

    CONSTANTS c_att_type_pdf TYPE soodk-objtp VALUE 'PDF' ##NO_TEXT.
    CONSTANTS c_linsz TYPE i VALUE 255.
    CONSTANTS c_obj_tp_raw TYPE so_obj_tp VALUE 'RAW' ##NO_TEXT.
    CONSTANTS c_valid_email_characters TYPE string VALUE '1234567890qwertyuopasdfghjklizxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM-_@.,!#$%&*+/\=?[]{}():<>' ##NO_TEXT.
ENDCLASS.



CLASS zcl_bc_mail_facade IMPLEMENTATION.


  METHOD cleanse_email_address.

    " Hazırlık """"""""""""""""""""""""""""""""""""""""""""""""""""""

    CHECK iv_address IS NOT INITIAL.

    " Yanlışlıkla girilmiş Türkçe karakterler """""""""""""""""""""""

    DATA(lv_address_no_tr) = iv_address.
    zcl_bc_text_toolkit=>replace_turkish_characters( CHANGING cv_text = lv_address_no_tr ).

    " Copy & Paste ile gelmiş TAB gibi karakterler """"""""""""""""""

    DATA(lv_char_pos) = 0.

    WHILE lv_char_pos < strlen( lv_address_no_tr ).
      DATA(lv_char) = |{ lv_address_no_tr+lv_char_pos(1) }|.

      IF lv_char CA c_valid_email_characters.
        rv_address = |{ rv_address }{ lv_char }|.
      ENDIF.

      ADD 1 TO lv_char_pos.
    ENDWHILE.

  ENDMETHOD.


  METHOD conv_symsg_to_body.

    DATA ls_symsg TYPE symsg.

*   Mesaj içeriğini oluştur

    IF is_symsg IS SUPPLIED.
      ls_symsg = is_symsg.
    ELSE.
      MOVE-CORRESPONDING sy TO ls_symsg.
    ENDIF.

    IF ls_symsg-msgty IS INITIAL.
      ls_symsg-msgty = zcl_bc_applog_facade=>c_msgty_s.
    ENDIF.

    APPEND INITIAL LINE TO rt_body ASSIGNING FIELD-SYMBOL(<lv_body>).

    MESSAGE ID     ls_symsg-msgid
            TYPE   ls_symsg-msgty
            NUMBER ls_symsg-msgno
            WITH   ls_symsg-msgv1 ls_symsg-msgv2 ls_symsg-msgv3 ls_symsg-msgv4
            INTO   <lv_body>.

  ENDMETHOD.


  METHOD get_email_of_user.
    SELECT SINGLE smtp_addr FROM adr6
      WHERE addrnumber = ( SELECT addrnumber FROM usr21 WHERE bname = @iv_uname ) AND
            persnumber = ( SELECT persnumber FROM usr21 WHERE bname = @iv_uname )
      INTO @rv_email ##WARN_OK.                         "#EC CI_NOORDER

    IF rv_email IS INITIAL AND iv_check = abap_true.
      RAISE EXCEPTION TYPE zcx_bc_user_master_data
        EXPORTING
          textid = zcx_bc_user_master_data=>email_missing
          uname  = iv_uname.
    ENDIF.
  ENDMETHOD.


  METHOD get_excel_columns_of_fcat.

    LOOP AT it_fcat ASSIGNING FIELD-SYMBOL(<ls_fcat>).

      APPEND VALUE #(
          zcolumn     = sy-tabix
          zcolumn_txt = <ls_fcat>-seltext_l
        ) TO rt_col.

    ENDLOOP.

  ENDMETHOD.


  METHOD get_excel_columns_of_table.

    DATA lt_fcat TYPE slis_t_fieldcat_alv.

    CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name       = iv_tabname
      CHANGING
        ct_fieldcat            = lt_fcat
      EXCEPTIONS
        inconsistent_interface = 1
        program_error          = 2
        OTHERS                 = 3.

    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    rt_col = get_excel_columns_of_fcat( lt_fcat ).

  ENDMETHOD.


  METHOD get_user_of_email.

    SELECT SINGLE u~bname
      INTO rv_bname
      FROM
        usr21 AS u
        INNER JOIN adr6 AS a ON
          a~persnumber = u~persnumber AND
          a~addrnumber = u~addrnumber
      WHERE smtp_addr = iv_smtp ##WARN_OK.              "#EC CI_NOORDER

    IF rv_bname IS INITIAL.
      RAISE EXCEPTION TYPE zcx_bc_user_master_data
        EXPORTING
          textid = zcx_bc_user_master_data=>user_email_nomatch
          email  = iv_smtp.
    ENDIF.

  ENDMETHOD.


  METHOD send_email.
    TRY.

        " Nesne """""""""""""""""""""""""""""""""""""""""""""""""""""

        DATA(lo_send_request) = cl_bcs=>create_persistent( ).

        lo_send_request->set_status_attributes( i_requested_status = iv_requested_status
                                                i_status_mail      = 'E' ).

        " Gönderen """"""""""""""""""""""""""""""""""""""""""""""""""

        IF iv_sender IS NOT INITIAL.
          lo_send_request->set_sender( cl_cam_address_bcs=>create_internet_address( iv_sender ) ).
        ELSE.
          lo_send_request->set_sender( cl_sapuser_bcs=>create( iv_from ) ).
        ENDIF.


        " Alıcılar (kullanıcı) """"""""""""""""""""""""""""""""""""""

        LOOP AT it_to ASSIGNING FIELD-SYMBOL(<lv_to>).
          TRY.
              DATA(lv_user_address)          = get_email_of_user( <lv_to> ).
              DATA(lv_cleansed_user_address) = cleanse_email_address( lv_user_address ).

              lo_send_request->add_recipient(
                  i_recipient = cl_cam_address_bcs=>create_internet_address( lv_cleansed_user_address )
                  i_express   = abap_true ).

            CATCH zcx_bc_user_master_data INTO DATA(lo_cx_bumd).
              IF iv_tolerate_no_addr = abap_false.
                RAISE EXCEPTION lo_cx_bumd.
              ENDIF.
          ENDTRY.

        ENDLOOP.

        " Alıcılar (E-Posta) """"""""""""""""""""""""""""""""""""""""

        LOOP AT it_rlist ASSIGNING FIELD-SYMBOL(<ls_rlist>).
          TRY.
              DATA(lv_cleansed_address) = cleanse_email_address( <ls_rlist>-smtpadr ).

              lo_send_request->add_recipient(
                  i_recipient = cl_cam_address_bcs=>create_internet_address( lv_cleansed_address )
                  i_express   = abap_true
                  i_copy       = <ls_rlist>-sndcp
                  i_blind_copy = <ls_rlist>-sndbc ).

            CATCH zcx_bc_user_master_data INTO lo_cx_bumd.
              IF iv_tolerate_no_addr = abap_false.
                RAISE EXCEPTION lo_cx_bumd.
              ENDIF.
          ENDTRY.

        ENDLOOP.

        " Alıcılar (Dağıtım listesi) """"""""""""""""""""""""""""""""

        IF it_dlist IS SUPPLIED.
          LOOP AT it_dlist ASSIGNING FIELD-SYMBOL(<ls_list>).
            TRY.
                lo_send_request->add_recipient(
                    i_recipient = cl_distributionlist_bcs=>getu_persistent(
                                      i_dliname = <ls_list>-dname
                                      i_private = '' )
                    i_express   =  abap_true ).

              CATCH zcx_bc_user_master_data INTO lo_cx_bumd.
                IF iv_tolerate_no_addr = abap_false.
                  RAISE EXCEPTION lo_cx_bumd.
                ENDIF.
            ENDTRY.
          ENDLOOP.
        ENDIF.

        " Hiç alıcı yoksa hata """"""""""""""""""""""""""""""""""""""

        IF it_to    IS INITIAL AND
           it_dlist IS INITIAL AND
           it_rlist IS INITIAL.

          IF iv_tolerate_no_addr = abap_false.
            RAISE EXCEPTION TYPE zcx_bc_method_parameter
              EXPORTING
                class_name  = 'ZCL_BC_MAIL_FACADE'
                method_name = 'SEND_EMAIL'
                textid      = zcx_bc_method_parameter=>param_error.
          ELSE.
            RETURN.
          ENDIF.

        ENDIF.

        " Konu + metin """"""""""""""""""""""""""""""""""""""""""""""

        DATA(lo_doc) = cl_document_bcs=>create_document( i_type    = c_obj_tp_raw
                                                         i_text    = it_body
                                                         i_subject = iv_subject ).
        IF iv_sensitivity IS NOT INITIAL.
          lo_doc->set_sensitivity( iv_sensitivity ).
        ENDIF.

        IF it_body_html IS NOT INITIAL.
          DATA(lo_doc_html) = cl_document_bcs=>create_document( i_type  = c_doc_type_htm
                                                                i_text    = it_body_html
                                                                i_subject = iv_subject ).
          IF iv_sensitivity IS NOT INITIAL.
            lo_doc_html->set_sensitivity( iv_sensitivity ).
          ENDIF.
        ENDIF.

        IF iv_long_subject IS NOT INITIAL.
          lo_send_request->set_message_subject( iv_long_subject ).
        ENDIF.

        " Ek dosyalar """""""""""""""""""""""""""""""""""""""""""""""

        IF it_att_bin IS SUPPLIED.
          LOOP AT it_att_bin ASSIGNING FIELD-SYMBOL(<ls_att_bin>).
            lo_doc->add_attachment( i_attachment_type    = <ls_att_bin>-att_type
                                    i_attachment_subject = <ls_att_bin>-att_subject
                                    i_att_content_hex    = <ls_att_bin>-att_content ).
          ENDLOOP.
        ENDIF.

        IF it_att_txt IS SUPPLIED.
          LOOP AT it_att_txt ASSIGNING FIELD-SYMBOL(<ls_att_txt>).
            lo_doc->add_attachment( i_attachment_type    = <ls_att_txt>-att_type
                                    i_attachment_subject = <ls_att_txt>-att_subject
                                    i_att_content_text   = <ls_att_txt>-att_content ).
          ENDLOOP.
        ENDIF.

        IF it_att_spool IS SUPPLIED.
          LOOP AT it_att_spool ASSIGNING FIELD-SYMBOL(<ls_att_spool>).

            zcl_bc_spool_toolkit=>conv_spool_to_pdf(
                EXPORTING iv_spoolid = <ls_att_spool>-spoolid
                          iv_partnum = <ls_att_spool>-partnum
                IMPORTING et_solix   = DATA(lt_pdf_solix) ).

            lo_doc->add_attachment( i_attachment_type    = c_att_type_pdf
                                    i_attachment_subject = <ls_att_spool>-att_subject
                                    i_att_content_hex    = lt_pdf_solix ).
          ENDLOOP.
        ENDIF.

        " Gönder """"""""""""""""""""""""""""""""""""""""""""""""""""

        lo_send_request->set_document( lo_doc ).

        IF it_body_html IS NOT INITIAL.
          lo_send_request->set_document( lo_doc_html ).
        ENDIF.

        IF lo_send_request->send( ) <> abap_true.
          RAISE EXCEPTION TYPE zcx_bc_mail_send
            EXPORTING
              textid = zcx_bc_mail_send=>cant_send.
        ELSE.
          IF iv_commit = abap_true.
            COMMIT WORK.
          ENDIF.
        ENDIF.

      CATCH zcx_bc_mail_send INTO DATA(lo_cx_ms).
        RAISE EXCEPTION lo_cx_ms.

      CATCH cx_root INTO DATA(lo_cx_root).
        RAISE EXCEPTION TYPE zcx_bc_mail_send
          EXPORTING
            textid   = zcx_bc_mail_send=>cant_send
            previous = lo_cx_root.

    ENDTRY.

  ENDMETHOD.


  METHOD send_email_with_sap_link.

    CHECK it_to    IS NOT INITIAL OR
          it_dlist IS NOT INITIAL.

    DATA(lv_login_user) = COND #(
        WHEN iv_login_user IS SUPPLIED
        THEN iv_login_user
        ELSE VALUE #( it_to[ 1 ] DEFAULT sy-uname ) ).

    DATA(lt_attachment) = VALUE tt_attachment_txt( (
        att_type    = 'SAP'
        att_subject = 'LINK'
        att_content = VALUE #(
          ( line = |[System]{ cl_abap_char_utilities=>cr_lf }| )
          ( line = |Name={ sy-sysid }{ cl_abap_char_utilities=>cr_lf }| )
          ( line = |Description={ cl_abap_char_utilities=>cr_lf }| )
          ( line = |Client={ sy-mandt }{ cl_abap_char_utilities=>cr_lf }| )
          ( line = |[User]{ cl_abap_char_utilities=>cr_lf }| )
          ( line = |Name={ lv_login_user }{ cl_abap_char_utilities=>cr_lf }| )
          ( line = |Language={ sy-langu }{ cl_abap_char_utilities=>cr_lf }| )
          ( line = |[Function]{ cl_abap_char_utilities=>cr_lf }| )
          ( line = |Title=={ cl_abap_char_utilities=>cr_lf }| )
          ( line = |Command={ iv_command }{ cl_abap_char_utilities=>cr_lf }| )
          ( line = |Type=Transaction{ cl_abap_char_utilities=>cr_lf }| )
          ( line = |[Configuration]{ cl_abap_char_utilities=>cr_lf }| )
          ( line = |GuiSize=Maximized{ cl_abap_char_utilities=>cr_lf }| ) ) ) ).

    send_email( it_to               = it_to
                it_dlist            = it_dlist
                iv_subject          = iv_subject
                iv_tolerate_no_addr = iv_tolerate_no_addr
                it_body             = it_body
                iv_commit           = iv_commit
                it_att_txt          = lt_attachment ).
  ENDMETHOD.


  METHOD send_excel_tables_email.
    DATA:
      lo_table        TYPE REF TO cl_abap_tabledescr,
      lo_str          TYPE REF TO cl_abap_structdescr,
      lo_element_type TYPE REF TO cl_abap_elemdescr,
      ls_field        TYPE dfies,
      lt_att_bin      TYPE tt_attachment_bin,
      lt_components   TYPE cl_abap_structdescr=>component_table,
      lt_binary_text  TYPE solix_tab,
      lv_sent_all     TYPE char1,
      lv_text         TYPE string,
      lv_text_tmp     TYPE text100,
      lv_zcolumn      TYPE column_z5_z5a.

    FIELD-SYMBOLS:
      <lt_excel_itab> TYPE ANY TABLE.

    TRY.
        " Attachment hazırlığı """"""""""""""""""""""""""""""""""""""
        LOOP AT it_excel_att ASSIGNING FIELD-SYMBOL(<ls_excel_att>).
          CLEAR lt_binary_text.

          ASSIGN <ls_excel_att>-itab_ref->* TO <lt_excel_itab>.

          lo_table     ?= cl_abap_typedescr=>describe_by_data( <lt_excel_itab> ).
          lo_str       ?= lo_table->get_table_line_type( ).
          lt_components = lo_str->get_components( ).

          LOOP AT <ls_excel_att>-exclude_columns INTO DATA(ls_excl).
            DELETE lt_components WHERE name = ls_excl-zcolumn_txt.
          ENDLOOP.

          LOOP AT lt_components ASSIGNING FIELD-SYMBOL(<fs_component>).
            lv_zcolumn = sy-tabix.

            IF sy-tabix > 1.
              CONCATENATE lv_text cl_bcs_convert=>gc_tab INTO lv_text.
            ENDIF.

            lo_element_type ?= <fs_component>-type.
            ls_field         = lo_element_type->get_ddic_field( ).

            READ TABLE <ls_excel_att>-columns
                 ASSIGNING FIELD-SYMBOL(<ls_columns>)
                 WITH KEY zcolumn = lv_zcolumn.

            IF sy-subrc = 0.
              ls_field-scrtext_l = <ls_columns>-zcolumn_txt.
            ENDIF.

            CONCATENATE lv_text ls_field-scrtext_l INTO lv_text.
          ENDLOOP.

          CONCATENATE lv_text cl_bcs_convert=>gc_crlf INTO lv_text.

          LOOP AT <lt_excel_itab> ASSIGNING FIELD-SYMBOL(<fs_row>).
            LOOP AT lt_components ASSIGNING <fs_component>.
              IF sy-tabix > 1.
                CONCATENATE lv_text cl_bcs_convert=>gc_tab INTO lv_text.
              ENDIF.

              ASSIGN COMPONENT <fs_component>-name OF STRUCTURE <fs_row> TO FIELD-SYMBOL(<fs_field>).
              WRITE <fs_field> TO lv_text_tmp.
              CONDENSE lv_text_tmp.
              CONCATENATE lv_text lv_text_tmp INTO lv_text.
            ENDLOOP.

            CONCATENATE lv_text cl_bcs_convert=>gc_crlf INTO lv_text.
          ENDLOOP.

          TRY.
              cl_bcs_convert=>string_to_solix(
                EXPORTING iv_string   = lv_text
                          iv_codepage = '4103' "suitable for MS Excel, leave empty"
                          iv_add_bom  = abap_true
                IMPORTING et_solix    = lt_binary_text ).

            CATCH cx_bcs.
              CONTINUE.
          ENDTRY.

          CHECK lt_binary_text IS NOT INITIAL.

          APPEND VALUE #( att_type    = 'XLS'
                          att_subject = <ls_excel_att>-filename
                          att_content = lt_binary_text
                        ) TO lt_att_bin.
        ENDLOOP.

        " Gönder """"""""""""""""""""""""""""""""""""""""""""""""""""
        send_email( it_to           = it_to
                    it_dlist        = it_dlist
                    it_rlist        = it_rlist
                    iv_subject      = iv_subject
                    iv_long_subject = iv_long_subject
                    it_body         = it_body[]
                    it_att_bin      = lt_att_bin
                    iv_commit       = iv_commit ).

      CATCH cx_root INTO DATA(lo_cx_root)  ##CATCH_ALL.
        RAISE EXCEPTION TYPE zcx_bc_mail_send
          EXPORTING
            previous = lo_cx_root
            textid   = zcx_bc_mail_send=>cant_send.
    ENDTRY.
  ENDMETHOD.


  METHOD send_excel_table_email.
    DATA(excel_attachment) = VALUE tt_excel_attachment( (
           itab_ref        = REF #( t_data )
           columns         = t_columns
           exclude_columns = it_exclude_columns
           filename        = iv_filename ) ).

    send_excel_tables_email(
      iv_subject      = iv_subject
      iv_long_subject = iv_long_subject
      it_body         = it_body
      it_to           = it_to
      it_rlist        = it_rlist
      it_dlist        = it_dlist
      it_excel_att    = excel_attachment
      iv_commit       = iv_commit ).
  ENDMETHOD.


  METHOD send_html_table_email.

    TYPES:
      BEGIN OF ty_mail_receiver,
        receiver TYPE so_recname,
      END OF ty_mail_receiver .

    DATA : lo_table    TYPE REF TO cl_abap_tabledescr,
           lo_str      TYPE REF TO cl_abap_structdescr,
           lt_fields   TYPE abap_compdescr_tab,
           lt_dli      TYPE TABLE OF sodlienti1,
           lv_dli_name TYPE soobjinfi1-obj_name,
           lv_dli_id   TYPE	soobjinfi1-object_id,
           ls_receiver TYPE ty_mail_receiver,
           ls_fields   TYPE abap_compdescr,
           lt_lines    TYPE TABLE OF tline.

    DATA : lt_output_soli TYPE TABLE OF soli,
           ls_output_soli TYPE          soli,
           lt_objpack     TYPE TABLE OF sopcklsti1,
           ls_objpack     TYPE          sopcklsti1,
           lt_objhead     TYPE TABLE OF solisti1,
           lt_objtxt      TYPE TABLE OF solisti1,
           ls_objtxt      TYPE          solisti1,
           lt_reclist     TYPE TABLE OF somlreci1,
           ls_reclist     TYPE          somlreci1,
           ls_doc_chng    TYPE          sodocchgi1.

    DATA : lv_lines       TYPE sy-tabix,
           lv_msg_lines   TYPE sy-tabix,
           lv_sent_all(1) TYPE c        ##NEEDED.

    DATA : lv_line_data    TYPE i,
           lv_line_columns TYPE i.


    TRY.
        DATA(lt_rcvlist) = t_rcvlist.

*       T_DATA kolon sayısı / T_COLUMNS kolon sayısı UYUMLU MU?
        lo_table ?= cl_abap_typedescr=>describe_by_data( t_data ).
        lo_str   ?= lo_table->get_table_line_type( ).
        APPEND LINES OF lo_str->components TO lt_fields.

        DESCRIBE TABLE lt_fields  LINES lv_line_data.
        DESCRIBE TABLE t_columns LINES lv_line_columns.

        IF lv_line_data <> lv_line_columns.
          RAISE EXCEPTION TYPE zcx_bc_mail_send
            EXPORTING
              textid = zcx_bc_mail_send=>column_number_not_valid.
        ENDIF.

*       Mail başlık
        IF iv_subject IS INITIAL.
          ls_doc_chng-obj_name  = TEXT-001.
          ls_doc_chng-obj_descr = TEXT-001.
        ELSE.
          ls_doc_chng-obj_name  = iv_subject.
          ls_doc_chng-obj_descr = iv_subject.
        ENDIF.

*       Mail HTML Body
        CLEAR ls_objtxt.
        ls_objtxt-line = '<body bgcolor = "#FFFFFF">'.
        APPEND ls_objtxt TO lt_objtxt.

        CLEAR ls_objtxt.
        CONCATENATE '<FONT COLOR = "#000000" face="Garamond">' '<b>'
               INTO ls_objtxt-line.
        APPEND ls_objtxt TO lt_objtxt.


        IF t_body IS INITIAL.
*       Mail body text / SO10
          CALL FUNCTION 'READ_TEXT'
            EXPORTING
              id                      = 'ST'
              language                = sy-langu
              name                    = iv_so10_object
              object                  = 'TEXT'
            TABLES
              lines                   = lt_lines
            EXCEPTIONS
              id                      = 1
              language                = 2
              name                    = 3
              not_found               = 4
              object                  = 5
              reference_check         = 6
              wrong_access_to_archive = 7
              OTHERS                  = 8.

          IF sy-subrc = 0.
            LOOP AT lt_lines ASSIGNING FIELD-SYMBOL(<s_lines>).
              html_body_txt  : <s_lines>-tdline.
            ENDLOOP.
          ENDIF.
        ELSE.
          LOOP AT t_body ASSIGNING FIELD-SYMBOL(<s_body>).
            html_body_txt  : <s_body>-tdline.
          ENDLOOP.
        ENDIF.


        CLEAR ls_objtxt.
        ls_objtxt-line = '<center>'.
        APPEND ls_objtxt TO lt_objtxt.

        CLEAR  ls_objtxt.
        ls_objtxt-line = '<TABLE  width= "100%" border="1">'.
        APPEND ls_objtxt TO lt_objtxt.

        LOOP AT t_columns ASSIGNING FIELD-SYMBOL(<s_columns>).
          IF sy-tabix = 1.
            html_hdr  : '<TR>' <s_columns>-zcolumn_txt ##NO_TEXT.
          ELSE.
            html_hdr  : ''     <s_columns>-zcolumn_txt ##NO_TEXT.
          ENDIF.
        ENDLOOP.

        LOOP AT t_data ASSIGNING FIELD-SYMBOL(<fs>).

          LOOP AT lt_fields INTO ls_fields.
            ASSIGN COMPONENT ls_fields-name OF STRUCTURE <fs> TO FIELD-SYMBOL(<fs_value>).

            IF sy-tabix = 1.
              html_itm : '<TR>' <fs_value> ##NO_TEXT.
            ELSE.
              html_itm : ''    <fs_value> ##NO_TEXT.
            ENDIF.
          ENDLOOP.

        ENDLOOP.


        ls_objtxt-line = '</TABLE>'.
        APPEND ls_objtxt TO lt_objtxt.
        CLEAR  ls_objtxt.

        ls_objtxt-line = '</center>'.
        APPEND ls_objtxt TO lt_objtxt.
        CLEAR ls_objtxt.

        ls_objtxt-line = '</FONT></body>'.
        APPEND ls_objtxt TO lt_objtxt.
        CLEAR ls_objtxt.


*       Packing
        DESCRIBE TABLE lt_objtxt LINES lv_msg_lines.
        READ TABLE lt_objtxt INTO ls_objtxt INDEX lv_msg_lines.

        ls_doc_chng-doc_size  = ( lv_msg_lines - 1 ) * c_linsz + strlen( ls_objtxt ).
        ls_objpack-transf_bin = ' '.
        ls_objpack-head_start = 1.
        ls_objpack-head_num   = 0.
        ls_objpack-body_start = 1.
        ls_objpack-body_num   = lv_msg_lines.
        ls_objpack-doc_type   = c_doc_type_htm.
        APPEND ls_objpack TO lt_objpack.
        CLEAR ls_objpack.

        DESCRIBE TABLE lt_output_soli LINES lv_lines.

        IF lv_lines <> 0.
          LOOP AT lt_output_soli INTO ls_output_soli.
            ls_objtxt = ls_output_soli.
            APPEND ls_objtxt TO lt_objtxt.
            CLEAR ls_objtxt.
          ENDLOOP.
        ENDIF.


        IF lt_rcvlist IS  INITIAL AND it_dlist IS NOT INITIAL.
          LOOP AT it_dlist ASSIGNING FIELD-SYMBOL(<ls_dlist>).
            lv_dli_name = <ls_dlist>-dname.
            lv_dli_id   = <ls_dlist>-dname.
            CLEAR lt_dli.
            CALL FUNCTION 'SO_DLI_READ_API1'
              EXPORTING
                dli_name                   = lv_dli_name
                dli_id                     = lv_dli_id
                shared_dli                 = abap_true
*             IMPORTING
*               DLI_DATA                   =
              TABLES
                dli_entries                = lt_dli
              EXCEPTIONS
                dli_not_exist              = 1
                operation_no_authorization = 2
                parameter_error            = 3
                x_error                    = 4
                OTHERS                     = 5.
            IF sy-subrc <> 0.
              MESSAGE ID sy-msgid TYPE 'I' NUMBER sy-msgno
                             WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4
                             DISPLAY LIKE 'E'.
              RETURN.
            ELSE.
              LOOP AT lt_dli INTO DATA(ls_dli).
                ls_receiver-receiver = ls_dli-member_adr.
                COLLECT ls_receiver INTO lt_rcvlist.
              ENDLOOP.
            ENDIF.

          ENDLOOP.
        ENDIF.
*       Mail receivers
        LOOP AT lt_rcvlist ASSIGNING FIELD-SYMBOL(<s_rcvlist>).
          ls_reclist-receiver = <s_rcvlist>-receiver.
          ls_reclist-rec_type = c_rec_type.
          ls_reclist-express  = c_express.
          ls_reclist-copy = abap_true.
          APPEND ls_reclist TO lt_reclist.
          FREE ls_reclist.
        ENDLOOP.


*       Send mail
        CALL FUNCTION 'SO_DOCUMENT_SEND_API1'
          EXPORTING
            document_data              = ls_doc_chng
            put_in_outbox              = 'X'
            commit_work                = 'X'
          IMPORTING
            sent_to_all                = lv_sent_all
          TABLES
            packing_list               = lt_objpack
            object_header              = lt_objhead
            contents_txt               = lt_objtxt
            receivers                  = lt_reclist
          EXCEPTIONS
            too_many_receivers         = 1
            document_not_sent          = 2
            document_type_not_exist    = 3
            operation_no_authorization = 4
            parameter_error            = 5
            x_error                    = 6
            enqueue_error              = 7
            OTHERS                     = 8.

        IF sy-subrc = 0.
          cl_os_transaction_end_notifier=>raise_commit_requested( ).
          CALL FUNCTION 'DB_COMMIT'.
          cl_os_transaction_end_notifier=>raise_commit_finished( ).
        ENDIF.

      CATCH zcx_bc_mail_send INTO DATA(lo_cx_html).
        RAISE EXCEPTION lo_cx_html.

      CATCH cx_root INTO DATA(lo_cx_root)  ##CATCH_ALL.
        RAISE EXCEPTION TYPE zcx_bc_mail_send
          EXPORTING
            previous = lo_cx_root
            textid   = zcx_bc_mail_send=>cant_send.

    ENDTRY.

  ENDMETHOD.


  METHOD send_symsg_as_email.
    send_email( it_body    = conv_symsg_to_body( is_symsg )
                it_to      = it_to
                iv_from    = iv_from
                iv_subject = iv_subject ).

  ENDMETHOD.


  METHOD validate_email_address.
    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " Source: https://www.abaptutorial.com/validate-email-regular-expression-abap/
    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    DATA(regex) = NEW cl_abap_regex( pattern     = '\w+(\.\w+)*@(\w+\.)+(\w{2,4})'
                                     ignore_case = abap_true ).

    DATA(matcher) = regex->create_matcher( text = email ).

    IF matcher->match( ) IS INITIAL.
      RAISE EXCEPTION TYPE zcx_bc_email_address
        EXPORTING
          textid = zcx_bc_email_address=>invalid_address
          email  = email.
    ENDIF.
  ENDMETHOD.
ENDCLASS.