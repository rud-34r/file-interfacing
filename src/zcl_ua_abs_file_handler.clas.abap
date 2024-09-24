CLASS zcl_ua_abs_file_handler DEFINITION
  PUBLIC
  ABSTRACT
  CREATE PROTECTED.
  PUBLIC SECTION.
    INTERFACES zif_file_interface ALL METHODS ABSTRACT .
  PROTECTED SECTION.
    DATA : content_tab TYPE cmis_t_string.
    METHODS: generate_data_for_file.
    METHODS: send_event importing file_id type sysuuid_c32.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_ua_abs_file_handler IMPLEMENTATION.

  METHOD generate_data_for_file.
"Functional Logic to gather data and update in content_tab
  ENDMETHOD.


  METHOD send_event.

    " Prepare the Event Hub URL
    DATA(lv_url) = 'https://namespace.servicebus.windows.net/file_interface/messages'.

    " Prepare SAS token
    DATA(lv_sas_token) = 'SharedAccessSignature sr=<resource-url>&sig=<signature>&se=<expiry>&skn=<key-name>'.


    DATA(lv_payload) = '{"fileID: "' && '"' && |{ file_id }| && '"}'.

    " Create HTTP Client
    TRY.
        DATA(lo_http_destination) = cl_http_destination_provider=>create_by_url( CONV #( lv_url ) ).
        DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( lo_http_destination ).


        lo_http_client->get_http_request( )->set_header_fields( VALUE #( ( name = if_web_http_header=>content_type value = if_web_http_header=>accept_application_json )
                                                                         ( name = if_web_http_header=>authorization value = lv_sas_token ) ) ).

        lo_http_client->get_http_request( )->set_text( lv_payload ).

        DATA(lo_http_response) = lo_http_client->execute( if_web_http_client=>post ).
      CATCH cx_http_dest_provider_error cx_web_http_client_error INTO DATA(lx_error).
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
