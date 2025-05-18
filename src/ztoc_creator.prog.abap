*&---------------------------------------------------------------------*
*& Report ZTOC_CREATOR
*&---------------------------------------------------------------------*

REPORT ztoc_creator.

  INCLUDE ztoc_creator_top.
  INCLUDE ztoc_creator_s01.
  INCLUDE ztoc_creator_lcd.
  INCLUDE ztoc_creator_lcu.
  INCLUDE ztoc_creator_lci.


  START-OF-SELECTION.

    TRY.
      go_toc = NEW #( p_order ).
    CATCH cx_task_is_released INTO go_exception.
      go_exception->show_message( ).
    ENDTRY.

    IF go_toc IS NOT BOUND.
      RETURN.
    ENDIF.

    go_toc->create_transport_of_copies( ).
    WRITE go_toc->v_message_to_user.
