*&---------------------------------------------------------------------*
*& Include          ZTOC_CREATOR_LCI
*&---------------------------------------------------------------------*

CLASS cx_task_is_released IMPLEMENTATION.

  METHOD show_message.
    MESSAGE TEXT-002 TYPE if_xo_const_message=>info.
  ENDMETHOD.

ENDCLASS.

CLASS lcl_transport_of_copies IMPLEMENTATION.

  METHOD constructor.

    IF task_is_released( v_transport_request ).
      RAISE EXCEPTION TYPE cx_task_is_released.
      RETURN.
    ENDIF.

    me->v_transport_request = condense( v_transport_request ).

  ENDMETHOD.

  METHOD task_is_released.

  DATA s_request_header TYPE tr001.

    CALL FUNCTION 'TR_READ_COMM'
      EXPORTING
        wi_trkorr             = v_transport_request " Request/Task
        wi_dialog             = abap_false          " Flag, whether information messages sent
        wi_sel_e070           = abap_true           " Read E070
      IMPORTING
        we_e070               = s_request_header    " Output field string: Request header (E070)
      EXCEPTIONS
        not_exist_e070        = 1                   " Request/task does not exist
        no_authorization      = 2                   " No authorization to read the request/task
        others                = 3.

    IF s_request_header-trstatus = 'R'.
      v_is_released = abap_true.
    ENDIF.

  ENDMETHOD.

  METHOD create_transport_of_copies.

    CALL FUNCTION 'TMW_CREATE_TRANSPORT_OF_COPIES'
      EXPORTING
        iv_for_non_abap               = abap_false
        iv_transport_target           = go_toc->c_qas
        iv_trkorr                     = go_toc->v_transport_request
        iv_no_export                  = abap_false
        iv_ignore_request_type        = abap_true
        iv_ignore_original_attributes = abap_false
      IMPORTING
        es_pre_transport              = go_toc->s_request_header
      EXCEPTIONS
        order_check_error             = 1
        enqueue_failed                = 2
        error_parameters              = 3
        reuse_request_failure         = 4
        create_order_failure          = 5
        export_request_failed         = 6
        configuration_error           = 7
        general_failure               = 8
        others                        = 9.

    IF go_toc->s_request_header-trkorr IS NOT INITIAL.
      go_toc->v_message_to_user = TEXT-003 && | | && go_toc->s_request_header-trkorr && | | && TEXT-004.
      RETURN.
    ENDIF.

    go_toc->v_message_to_user = zcl_general=>get_return_message( ).

  ENDMETHOD.

ENDCLASS.