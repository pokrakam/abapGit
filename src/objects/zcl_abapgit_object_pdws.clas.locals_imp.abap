

interface lif_wf_definition.

endinterface.

CLASS lcl_wf_definition DEFINITION CREATE PUBLIC FINAL.

  PUBLIC SECTION.
    INTERFACES lif_wf_definition.
    CLASS-METHODS load IMPORTING iv_objid         TYPE hrobject-objid
                       RETURNING VALUE(ri_result) TYPE REF TO lif_wf_definition
                       RAISING   zcx_abapgit_exception.
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_wf_definition IMPLEMENTATION.

  METHOD load.

  ENDMETHOD.

ENDCLASS.
