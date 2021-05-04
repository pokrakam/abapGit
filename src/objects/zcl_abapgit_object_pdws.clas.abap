CLASS zcl_abapgit_object_pdws DEFINITION
  PUBLIC
  INHERITING FROM zcl_abapgit_object_pdxx_super
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS constructor IMPORTING is_item     TYPE zif_abapgit_definitions=>ty_item
                                  iv_language TYPE spras
                        RAISING   zcx_abapgit_exception.

    METHODS zif_abapgit_object~serialize REDEFINITION.
    METHODS zif_abapgit_object~deserialize REDEFINITION.
    METHODS zif_abapgit_object~changed_by REDEFINITION.

  PROTECTED SECTION.

  PRIVATE SECTION.
    CONSTANTS c_object_type_workflow TYPE hr_sotype VALUE 'WS'.

ENDCLASS.


CLASS zcl_abapgit_object_pdws IMPLEMENTATION.

  METHOD constructor.

    super->constructor( is_item     = is_item
                        iv_language = iv_language ).

    IF is_experimental( ) = abap_false.
      "Work in progress
      zcx_abapgit_exception=>raise( 'PDWS is still work in progress, enable experimental features to test it' ).
    ENDIF.

    ms_objkey-otype = 'WS'.
    ms_objkey-objid = ms_item-obj_name.

  ENDMETHOD.


  METHOD zif_abapgit_object~changed_by.

    SELECT SINGLE uname
      INTO rv_user
      FROM hrs1205
      WHERE otype = ms_objkey-otype AND
            objid = ms_objkey-objid.

    IF sy-subrc <> 0.
      rv_user = c_user_unknown.
    ENDIF.

  ENDMETHOD.


  METHOD zif_abapgit_object~deserialize.

  ENDMETHOD.


  METHOD zif_abapgit_object~serialize.

    DATA: ls_wf_definition_key TYPE swd_wfdkey,

          lo_wfd_xml           TYPE REF TO cl_xml_document_base,
          lo_wfd_export        TYPE REF TO if_swf_pdef_export,
          lt_versions          TYPE TABLE OF swd_versns,

          lo_node              TYPE REF TO if_ixml_element,

          ls_definition        TYPE hrsobject.

    ls_definition = 'WS90000001'.

    CALL FUNCTION 'SWD_GET_VERSIONS_OF_WORKFLOW'
      EXPORTING
        im_task          = ls_definition
        im_exetyp        = 'S'
      IMPORTING
        ex_active_wfdkey = ls_wf_definition_key
      TABLES
        ex_versions      = lt_versions.

    CREATE OBJECT lo_wfd_export TYPE cl_wfd_convert_def_to_ixml.

    lo_wfd_xml = lo_wfd_export->convert( load_from_db = abap_true
                                         language = sy-langu
                                         wfd_key = ls_wf_definition_key ).

    lo_node->append_child( lo_wfd_xml->get_first_node( ) ).
    io_xml->add_xml( iv_name = 'PDWS'
                     ii_xml = lo_node ).

  ENDMETHOD.

ENDCLASS.
