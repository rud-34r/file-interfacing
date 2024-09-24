CLASS zcl_ua_request_handler DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_http_service_extension .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.




CLASS zcl_ua_request_handler IMPLEMENTATION. "Generic HTTP handler for incoming requests from Azure compute function.

  METHOD if_http_service_extension~handle_request.

    CASE request->get_method( ).
      WHEN CONV #( if_web_http_client=>post ).

        "It was assumed that azure sends request in a post with storage type in a header field
        DATA(lv_valid) = cl_http_service_utility=>handle_csrf( EXPORTING request = request
                                                                         response = response ).

        IF lv_valid EQ abap_true.
          "Factory class responsible for generating handler instance depending on storage type

          DATA(lo_file_handler) = zcl_ua_file_storage_factory=>get_instance( storage_type = request->get_header_field( 'storage-type' ) ).
          lo_file_handler->upload_file( request->get_header_field( 'process-type' ) ).

          CASE request->get_header_field( 'process-type' ).
            WHEN 'SYNC'.
              response->set_status( if_web_http_status=>created ).
            WHEN 'ASYNC'.
              response->set_status( if_web_http_status=>accepted ).
          ENDCASE.
        ELSE.
          response->set_status( if_web_http_status=>forbidden ).
        ENDIF.
        EXIT.
    ENDCASE.
  ENDMETHOD.
ENDCLASS.
