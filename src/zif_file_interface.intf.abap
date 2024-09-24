INTERFACE zif_file_interface
  PUBLIC .
  METHODS: upload_file importing process_type type string returning value(file_name) type sysuuid_c32.

ENDINTERFACE.
