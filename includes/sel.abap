*&---------------------------------------------------------------------*
*&  Include           CUSTOMER_MANAGEMENT_SERVICE_SEL
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK bk1 WITH FRAME TITLE TEXT-001.
  PARAMETERS: rbut1 RADIOBUTTON GROUP gr1 DEFAULT 'X' USER-COMMAND uc1 MODIF ID id9,
              rbut2 RADIOBUTTON GROUP gr1 MODIF ID id9.
SELECTION-SCREEN END OF BLOCK bk1.

SELECTION-SCREEN BEGIN OF BLOCK bk2 WITH FRAME TITLE TEXT-002.
  SELECTION-SCREEN BEGIN OF LINE.
    SELECTION-SCREEN COMMENT 1(15) TEXT-004 MODIF ID id1.
    PARAMETERS: p_kunnr TYPE kna1-kunnr MODIF ID id1.
  SELECTION-SCREEN END OF LINE.

  SELECTION-SCREEN BEGIN OF LINE.
    SELECTION-SCREEN COMMENT 1(15) TEXT-005 MODIF ID id1.
    PARAMETERS: p_land1 TYPE kna1-land1 MODIF ID id1.
  SELECTION-SCREEN END OF LINE.

  SELECTION-SCREEN BEGIN OF LINE.
    SELECTION-SCREEN COMMENT 1(15) TEXT-006 MODIF ID id1.
    PARAMETERS: p_name1 TYPE kna1-name1 MODIF ID id1.
  SELECTION-SCREEN END OF LINE.

  SELECTION-SCREEN BEGIN OF LINE.
    SELECTION-SCREEN COMMENT 1(15) TEXT-007 MODIF ID id1.
    PARAMETERS: p_ort01 TYPE kna1-ort01 MODIF ID id1.
  SELECTION-SCREEN END OF LINE.

  SELECTION-SCREEN BEGIN OF LINE.
    SELECTION-SCREEN COMMENT 1(15) TEXT-008 MODIF ID id1.
    PARAMETERS: p_pstlz TYPE kna1-pstlz MODIF ID id1.
  SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK bk2.

SELECTION-SCREEN PUSHBUTTON 1(20) TEXT-009 USER-COMMAND fc1 MODIF ID id1.

SELECTION-SCREEN BEGIN OF BLOCK bk3 WITH FRAME TITLE TEXT-003.
  SELECT-OPTIONS: sl_kunnr FOR kna1-kunnr MODIF ID id2.
SELECTION-SCREEN END OF BLOCK bk3.

SELECTION-SCREEN PUSHBUTTON 1(20) TEXT-010 USER-COMMAND fc2 MODIF ID id2.

*TEXT ELEMENTS TO BE INCLUDED IN "TEXTS".
*-----------Text Symbols Sheet-----------
*001 - Program mode
*002 - New client's data
*003 - Orders
*004 - Customer number
*005 - Country
*006 - Name
*007 - City
*008 - Postal code
*009 - Add customer
*010 - Find orders
*----------Selection Texts Sheet---------
*RBUT1 - New client's insertion
*RBUT2 - Orders
*sl_kunnr - Customer number