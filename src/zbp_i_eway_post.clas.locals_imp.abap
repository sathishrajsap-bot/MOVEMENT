CLASS lhc_ZI_EWAY_POST DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_eway_post RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR zi_eway_post RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE zi_eway_post.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zi_eway_post.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE zi_eway_post.

    METHODS read FOR READ
      IMPORTING keys FOR READ zi_eway_post RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zi_eway_post.

ENDCLASS.

CLASS lhc_ZI_EWAY_POST IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD create.
    TYPES:
      BEGIN OF ty_ewbeinvoicelist,
        irn        TYPE string,
        distance   TYPE string,
        transmode  TYPE string,
        transid    TYPE string,
        transname  TYPE string,
        transdocdt TYPE string,
        transdocno TYPE string,
        vehno      TYPE string,
        vehtype    TYPE string,
      END OF ty_ewbeinvoicelist,

      BEGIN OF ty_expshipdtls,
        nm    TYPE string,
        addr1 TYPE string,
        addr2 TYPE string,
        loc   TYPE string,
        pin   TYPE string,
        stcd  TYPE string,
      END OF ty_expshipdtls,


      BEGIN OF ty_request_data,
        clientcode      TYPE string,
        usercode        TYPE string,
        password        TYPE string,
        ewbeinvoicelist TYPE TABLE OF ty_ewbeinvoicelist WITH EMPTY KEY,
        expshipdtls     TYPE ty_expshipdtls,
      END OF ty_request_data.

*    TYPES : BEGIN OF ty_str,
*              flag           TYPE string, ": false,
*              message        TYPE string, ": "Check GSTIN combination present in EWB portal! for document no 30110005GP",
*              ewbno          TYPE string, ": null,
*              ewbdt          TYPE string, ": null,
*              ewbvalidtill   TYPE string, ": null,
*              alert          TYPE string, ": null,
*              docno          TYPE string, ": "30110005GP",
*              docdate        TYPE string, ": "23/11/2021",
*              pdfurl         TYPE string, ": null,
*              detailedpdfurl TYPE string, ": null,
*              jsondata       TYPE string, ": null,
*              error_log_id   TYPE string, ": null,
*              doctype        TYPE string, ": null
*              irn            TYPE string,
*            END OF ty_str.

*    DATA : lt_resp TYPE TABLE OF ty_str,
*           ls_resp TYPE ty_str.

    TYPES: BEGIN OF ty_info_dtls,
             infcd    TYPE string,
             "DESC is keyword, so use different field name
             descr    TYPE string,
             cancdesc TYPE string,
           END OF ty_info_dtls.

    TYPES: tt_info_dtls TYPE STANDARD TABLE OF ty_info_dtls WITH EMPTY KEY.

    TYPES: BEGIN OF ty_response,
             flag           TYPE abap_bool,
             message        TYPE string,
             irn            TYPE string,
             ewbno          TYPE string,
             ewbdt          TYPE string,
             ewbvalidtill   TYPE string,
             pdfurl         TYPE string,
             detailedpdfurl TYPE string,
             infodtls       TYPE tt_info_dtls,
             remarks        TYPE string,
             error_log_id   TYPE string,
           END OF ty_response.
    DATA : lt_resp TYPE TABLE OF ty_response,
           ls_resp TYPE ty_response.

    DATA : ls_irn  TYPE ty_ewbeinvoicelist,
           lt_eway TYPE TABLE OF ty_request_data,
           ls_eway TYPE ty_request_data.
*             lt_repon TYPE TABLE OF zsd_t_inv_rsp,
*             ls_repon TYPE zsd_t_inv_rsp.

    DATA:   lv_jsonstatus TYPE string.

    DATA : lv_in         TYPE string,
           rv_out        TYPE string,
           lv_eway_date  TYPE string,
           lv_eway_date1 TYPE string,
           lv_eway_vali  TYPE string,
           lv_eway_vali1 TYPE string,
           lv_url        TYPE string.
    DATA: lt_response TYPE TABLE OF zdb_einv_resp,
          ls_response TYPE zdb_einv_resp.

    SELECT * FROM zi_billing_header FOR ALL ENTRIES IN @entities WHERE BillingDoc = @entities-documentno INTO TABLE @DATA(lt_final).
    SELECT * FROM zi_gen_eway FOR ALL ENTRIES IN @lt_final WHERE BillingDocument = @lt_final-BillingDoc INTO TABLE @DATA(lt_IRN).
    SELECT * FROM zdb_einv_resp FOR ALL ENTRIES IN @lt_final WHERE docno = @lt_final-BillingDoc INTO TABLE @lt_response.
    LOOP AT entities INTO DATA(ls_entity).
      LOOP AT lt_final INTO DATA(ls_final).
        READ TABLE lt_irn INTO DATA(ls_ir) WITH KEY BillingDocument = ls_final-BillingDoc.
        ls_irn-irn = ls_ir-irn.
        ls_irn-transname = ls_final-TransName.
        ls_irn-vehno = ls_final-VehNo.
        ls_irn-vehtype = ls_final-VehType.
        ls_irn-transid = ls_final-TransId.
        ls_irn-transmode = '1'.
*        IF ls_final-di IS NOT INITIAL.
*          ls_irn-distance = ls_final-distance.
*        ELSE.
        ls_irn-distance = 0.
*        ENDIF.
        APPEND ls_irn TO ls_eway-ewbeinvoicelist.
      ENDLOOP.

      IF sy-sysid = 'DUW'.
        ls_eway-clientcode =  'ptmuT'.
        ls_eway-usercode = 'ENEXIO_DEMO'.
        ls_eway-password = 'Enexio@123' .


      ELSE.

*        ls_eway-clientcode = 'RfMG9'.
*        ls_eway-password  = 'Besmak@123'.
*        ls_eway-usercode = 'Besmak_Admin'.

      ENDIF.
      DATA(lo_json) = NEW /ui2/cl_json( ).
      lv_jsonstatus = lo_json->serialize( data = ls_eway ).


      lv_in = lv_jsonstatus.

      IF  sy-sysid = 'DUW'.
        lv_url =  'https://uat-api.logitax.in/einvext/v1/GenerateEWBEinvoice'.
      ELSE.
        lv_url = 'https://api.logitax.in/einvext/v1/GenerateEWBEinvoice' .
      ENDIF.

      DATA(lo_http_destination) =
                cl_http_destination_provider=>create_by_url( lv_url ).

      DATA(lo_web_http_client) = cl_web_http_client_manager=>create_by_http_destination( lo_http_destination ) .
      DATA(lo_web_http_request) = lo_web_http_client->get_http_request( ).

**Payload

      lo_web_http_client = cl_web_http_client_manager=>create_by_http_destination( lo_http_destination ) .

      lo_web_http_request = lo_web_http_client->get_http_request( ).

      lo_web_http_request->set_text(
                               EXPORTING
                               i_text   = lv_in  ).
      DATA(lo_web_http_response_post) = lo_web_http_client->execute( if_web_http_client=>post ).

      DATA(lv_response_post) = lo_web_http_response_post->get_text( ).

      DATA(lv_response_status) = lo_web_http_response_post->get_status( ).

      DATA(rv_response) = lv_response_post.

      /ui2/cl_json=>deserialize(
        EXPORTING
          json = lv_response_post
        CHANGING
          data = lt_resp
      ).
      READ TABLE lt_resp INTO ls_resp WITH KEY flag = abap_true.
      IF sy-subrc IS INITIAL.
        READ TABLE lt_response ASSIGNING FIELD-SYMBOL(<fs_response>) WITH KEY docno = ls_entity-documentno.
        <fs_response>-ewbno = ls_resp-ewbno.
        <fs_response>-ewbdt = ls_resp-ewbdt.
        <fs_response>-pdfurl = ls_resp-pdfurl.
        <fs_response>-detailedpdfurl = ls_resp-detailedpdfurl.
        MODIFY zdb_einv_resp  FROM TABLE @lt_response .
        APPEND VALUE #(
                          %cid = ls_entity-%cid
                          documentno = ls_entity-documentno
                          status = 'Generated'
                          message = ls_resp-message
                          irn = ls_resp-irn
                          ewbno = ls_resp-ewbno
                          ewbdt = ls_resp-ewbdt
                          ackno = ls_entity-ackno
                          ackdate = ls_entity-ackdate
                          createdby = sy-uname
                          createddt = sy-datum
                          createdtime = sy-uzeit
                          pdfurl = ls_resp-pdfurl
                          detailedpdfurl = ls_resp-detailedpdfurl
                          )
                          TO mapped-zi_eway_post.

      ELSE.
        READ TABLE lt_resp INTO ls_resp INDEX 1.
        APPEND VALUE #(
                                 %cid = ls_entity-%cid
                                 documentno = ls_entity-documentno
                                 status = 'Error'
                                 message = ls_resp-message
                                 irn = ls_resp-irn
                                 ewbno = ls_resp-ewbno
                                 ewbdt = ls_resp-ewbdt
                                 ackno = ls_entity-ackno
                                 ackdate = ls_entity-ackdate
                                 createdby = sy-uname
                                 createddt = sy-datum
                                 createdtime = sy-uzeit
                                 pdfurl = ls_resp-pdfurl
                                 detailedpdfurl = ls_resp-detailedpdfurl
                                 )
                                 TO mapped-zi_eway_post.

      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD update.
  ENDMETHOD.

  METHOD delete.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZI_EWAY_POST DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZI_EWAY_POST IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
