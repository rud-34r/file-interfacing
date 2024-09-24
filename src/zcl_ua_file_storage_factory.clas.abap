CLASS zcl_ua_file_storage_factory DEFINITION
  PUBLIC
  ABSTRACT
  FINAL
  CREATE public.

  PUBLIC SECTION.
    CLASS-METHODS: get_instance IMPORTING storage_type      TYPE string
                                RETURNING VALUE(ro_handler) TYPE REF TO zif_file_interface.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_ua_file_storage_factory IMPLEMENTATION.
  METHOD get_instance.
    CASE storage_type.
      WHEN 'BLOB'.
        ro_handler = NEW zcl_ua_file_handler_for_blob(  ).
    ENDCASE.
  ENDMETHOD.

ENDCLASS.
