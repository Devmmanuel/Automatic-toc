*&---------------------------------------------------------------------*
*& Include          ZTOC_CREATOR_LCD
*&---------------------------------------------------------------------*

CLASS cx_task_is_released DEFINITION FINAL INHERITING FROM cx_static_check.

  PUBLIC SECTION.
    METHODS show_message.

ENDCLASS.

CLASS lcl_transport_of_copies DEFINITION FINAL.

  PUBLIC SECTION.

    CONSTANTS c_qas TYPE e070-tarsystem VALUE 'A4H'.

    DATA v_message_to_user   TYPE bapi_msg.
    DATA v_transport_request TYPE e070-trkorr.
    DATA s_request_header    TYPE tr001.

    METHODS constructor
      IMPORTING v_transport_request TYPE trkorr
      RAISING cx_task_is_released.

    METHODS task_is_released
      IMPORTING v_transport_request TYPE trkorr
      RETURNING VALUE(v_is_released) TYPE abap_bool.

    METHODS create_transport_of_copies.

ENDCLASS.