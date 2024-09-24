CLASS zcl_ua_file_handler_for_blob DEFINITION INHERITING FROM zcl_ua_abs_file_handler
  PUBLIC
  FINAL
  CREATE PUBLIC.
  PUBLIC SECTION.

    METHODS: zif_file_interface~upload_file REDEFINITION.
    METHODS constructor.

  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA : file_id TYPE sysuuid_c32.
    METHODS: put_file_to_blob.
ENDCLASS.



CLASS zcl_ua_file_handler_for_blob IMPLEMENTATION.

  METHOD constructor.

    super->constructor( ).

    TRY.
        me->file_id  = cl_uuid_factory=>create_system_uuid(  )->create_uuid_c32( ).
      CATCH cx_uuid_error.
        "handle exception
    ENDTRY.

  ENDMETHOD.


  METHOD zif_file_interface~upload_file.
    generate_data_for_file(  ).
    put_file_to_blob(  ).
    CASE process_type.
      WHEN 'SYNC'.
        EXIT.
      WHEN 'ASYNC'.
        send_event( file_id = me->file_id ).
    ENDCASE.

    file_name = file_id.
  ENDMETHOD.


  METHOD put_file_to_blob.

  ENDMETHOD.

ENDCLASS.
