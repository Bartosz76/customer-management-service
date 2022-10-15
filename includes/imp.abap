*&---------------------------------------------------------------------*
*&  Include           CUSTOMER_MANAGEMENT_SERVICE_IMP
*&---------------------------------------------------------------------*

*----------------------------------------------------------------------*
*       CLASS lcl_params_validator IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS lcl_params_validator IMPLEMENTATION.
  METHOD check_if_initial.
    IF rbut1 = 'X'.
      check_kunnr( ).
      check_land1( ).
      check_name1( ).
      check_ort01( ).
      check_pstlz( ).
    ENDIF.
  ENDMETHOD.                    "check_if_initial

  METHOD check_kunnr.
    IF p_kunnr IS INITIAL.
      MESSAGE s000(zbmierzwi_test_msg) DISPLAY LIKE 'E'.
      LEAVE LIST-PROCESSING.
    ENDIF.
  ENDMETHOD.                    "check_kunnr

  METHOD check_land1.
    IF p_land1 IS INITIAL.
      MESSAGE s001(zbmierzwi_test_msg) DISPLAY LIKE 'E'.
      LEAVE LIST-PROCESSING.
    ENDIF.
  ENDMETHOD.                    "check_land1

  METHOD check_name1.
    IF p_name1 IS INITIAL.
      MESSAGE s002(zbmierzwi_test_msg) DISPLAY LIKE 'E'.
      LEAVE LIST-PROCESSING.
    ENDIF.
  ENDMETHOD.                    "check_name1

  METHOD check_ort01.
    IF p_ort01 IS INITIAL.
      MESSAGE s003(zbmierzwi_test_msg) DISPLAY LIKE 'E'.
      LEAVE LIST-PROCESSING.
    ENDIF.
  ENDMETHOD.                    "check_ort01

  METHOD check_pstlz.
    IF p_pstlz IS INITIAL.
      MESSAGE s004(zbmierzwi_test_msg) DISPLAY LIKE 'E'.
      LEAVE LIST-PROCESSING.
    ENDIF.
  ENDMETHOD.                    "check_pstlz
ENDCLASS.                    "lcl_params_validator IMPLEMENTATION

*----------------------------------------------------------------------*
*       CLASS lcl_screen_adjuster IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS lcl_screen_adjuster IMPLEMENTATION.
  METHOD constructor.
    me->lo_element_remover = i_lo_element_remover.
    me->lo_visibility_dispenser = i_lo_visibility_dispenser.
  ENDMETHOD.

  METHOD adjust_screen.
    lo_element_remover->hide_onli( ).
    IF rbut1 = 'X'.
      lo_visibility_dispenser->make_block_visible( 'ID1' ).
    ELSEIF rbut2 = 'X'.
      lo_visibility_dispenser->make_block_visible( 'ID2' ).
    ENDIF.
  ENDMETHOD.                    "adjust_screen
ENDCLASS.                    "lcl_screen_adjuster IMPLEMENTATION

*----------------------------------------------------------------------*
*       CLASS lcl_visibility_dispenser IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS lcl_visibility_dispenser IMPLEMENTATION.
  METHOD make_all_blocks_inv.
    LOOP AT SCREEN.
      IF screen-group1 = 'ID1' OR screen-group1 = 'ID2'.
        screen-invisible = '1'.
        screen-input = '0'.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.                    "make_all_blocks_inv

  METHOD make_block_visible.
    CASE marker.
      WHEN 'ID1'.
        LOOP AT SCREEN.
          IF screen-group1 = 'ID2'.
            screen-invisible = '1'.
            screen-input = '0'.
            MODIFY SCREEN.
          ELSE.
            screen-invisible = '0'.
            screen-input = '1'.
            MODIFY SCREEN.
          ENDIF.
        ENDLOOP.
      WHEN 'ID2'.
        LOOP AT SCREEN.
          IF screen-group1 = 'ID1'.
            screen-invisible = '1'.
            screen-input = '0'.
            MODIFY SCREEN.
          ELSE.
            screen-invisible = '0'.
            screen-input = '1'.
            MODIFY SCREEN.
          ENDIF.
        ENDLOOP.
    ENDCASE.
  ENDMETHOD.                    "make_block_visible
ENDCLASS.                    "lcl_visibility_dispenser IMPLEMENTATION

*----------------------------------------------------------------------*
*       CLASS lcl_element_remover IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS lcl_element_remover IMPLEMENTATION.
  METHOD hide_onli.
    DATA: lt_tab TYPE TABLE OF sy-ucomm.
    APPEND 'ONLI' TO lt_tab.
    CALL FUNCTION 'RS_SET_SELSCREEN_STATUS'
      EXPORTING
        p_status        = sy-pfkey
      TABLES
        p_exclude       = lt_tab.
  ENDMETHOD.                    "hide_onli
ENDCLASS.                    "lcl_element_remover IMPLEMENTATION

*----------------------------------------------------------------------*
*       CLASS lcl_customer_inserter IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS lcl_customer_inserter IMPLEMENTATION.
  METHOD insert_new_customer.
    DATA: lwa_customer TYPE kna1.
    lwa_customer-kunnr = p_kunnr.
    lwa_customer-land1 = p_land1.
    lwa_customer-name1 = p_name1.
    lwa_customer-ort01 = p_ort01.
    lwa_customer-pstlz = p_pstlz.

    INSERT kna1 FROM lwa_customer.
  ENDMETHOD.                    "make_block_visible
ENDCLASS.                    "lcl_customer_inserter IMPLEMENTATION

*----------------------------------------------------------------------*
*       CLASS lcl_action_handler IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS lcl_action_handler IMPLEMENTATION.
  METHOD constructor.
    IF i_o_action IS INSTANCE OF lcl_customer_inserter.
      lo_customer_inserter = CAST lcl_customer_inserter( i_o_action ).
    ELSEIF i_o_action IS INSTANCE OF lcl_cds_data_selector.
      lo_cds_data_selector = CAST lcl_cds_data_selector( i_o_action ).
    ENDIF.
  ENDMETHOD.                    "constructor

  METHOD decide_action.
    CASE sy-ucomm.
      WHEN 'FC1'.
        lo_customer_inserter->insert_new_customer( ).
        IF sy-subrc = 0.
          MESSAGE 'The customer inserted successfully.' TYPE 'I'.
        ELSE.
          MESSAGE 'The insertion failed.' TYPE 'I'.
        ENDIF.
      WHEN 'FC2'.

    ENDCASE.
  ENDMETHOD.                    "decide_action
ENDCLASS.                    "lcl_customer_inserter IMPLEMENTATION

*----------------------------------------------------------------------*
*       CLASS lcl_cds_data_selector IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS lcl_cds_data_selector IMPLEMENTATION.
*  METHOD get_seltab.
*    e_lt_seltab = lt_seltab.
*  ENDMETHOD.

  METHOD gather_sl_data.
    DATA: wa_seltab TYPE selopttab.
    LOOP AT sl_kunnr INTO wa_seltab.
      wa_seltab-sign   = sl_kunnr-sign.
      wa_seltab-option = sl_kunnr-option.
      wa_seltab-low    = sl_kunnr-low.
      wa_seltab-high   = sl_kunnr-high.
      APPEND wa_seltab TO lt_seltab.
    ENDLOOP.
    e_lt_seltab = lt_seltab.
  ENDMETHOD.                    "gather_sl_data

  METHOD supply_orders.
    SELECT vbeln erzet erdat route btgew
      FROM likp
      INTO CORRESPONDING FIELDS OF TABLE lt_orders
      WHERE kunnr IN i_lt_seltab.
  ENDMETHOD.                    "supply_orders
ENDCLASS.                    "lcl_cds_data_selector IMPLEMENTATION

*----------------------------------------------------------------------*
*       CLASS lcl_factory IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS lcl_factory IMPLEMENTATION.
  METHOD provide_object.
    IF rbut1 = 'X'.
      DATA(lo_customer_inserter) = NEW lcl_customer_inserter( ).
      e_o_action = lo_customer_inserter.
    ELSEIF rbut2 = 'X'.
      DATA(lo_cds_data_selector) = NEW lcl_cds_data_selector( ).
      e_o_action = lo_cds_data_selector.
    ENDIF.
  ENDMETHOD.
ENDCLASS.                    "lcl_factory IMPLEMENTATION

*MESSAGES TO BE INCLUDED IN THE MESSAGE CLASS.
*-----------Attributes Sheet-----------
*Short description - Messages for Customer Management Service.
*---------------Messages---------------
*000 - Please, provide the customer's number.
*001 - Please, provide the customer's country.
*002 - Please, provide the customer's name.
*003 - Please, provide the customer's city.
*004 - Please, provide the customer's postal code.