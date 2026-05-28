CLASS zcl_api_posting DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS call_api
      IMPORTING
        iv_url      TYPE string
        iv_payload  TYPE string
      EXPORTING
        rv_response TYPE string.


  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_API_POSTING IMPLEMENTATION.


  METHOD call_api.

    DATA: lo_http_client TYPE REF TO if_web_http_client.
    DATA(lv_url) = 'https://uat-api.logitax.in/einvext/v1/GenerateJSONEInvoice'.

    DATA(lv_payload) = '{"client_code": "ptmuT","user_code": "ENEXIO_DEMO","password": "Enexio@123","json_data": {"Version": "1.1","TranDtls": {' &&
    '"TaxSch": "GST","SupTyp": "B2B","RegRev": "N","EcmGstin": "","IgstOnIntra": "N"},"DocDtls": {"Typ": "INV","No": "90000056","Dt": "24/04/2026"},' &&
    '"SellerDtls": {"Gstin": "27AAAPI3182M002","Lglnm": "BOC/IMPORT - DRY COOLING","Trdnm": "BOC/IMPORT - DRY COOLING","Addr1": "Avvai Shanmugam Salai, Royapettah",' &&
    '"Addr2": "Avvai Shanmugam Salai, Royapettah","Loc": "Chennai","Pin": 600018,"Stcd": "33","Ph": "","Em": ""},"BuyerDtls": {"Gstin": "24AAAPI3182M002",' &&
    '"Lglnm": "JINDAL URBAN WASTE MANAGEMENT (JODH PVT LTD","Trdnm": "JINDAL URBAN WASTE MANAGEMENT (JODH PVT LTD",' && '"Pos": "08","Addr1": "28 Shivaji Marg",' &&
    '"Addr2": "28 Shivaji Marg","Loc": "","Pin": 302005,"Stcd": "08","Ph": "","Em": ""},"DispDtls": {"Nm": "","Addr1": "","Addr2": "","Loc": "","Pin": "","Stcd": ""' &&
    '},"ShipDtls": {"Gstin": "24AAAPI3182M002","Lglnm": "JINDAL URBAN WASTE MANAGEMENT (JODH PVT LTD","Trdnm": "JINDAL URBAN WASTE MANAGEMENT (JODH PVT LTD",' &&
    '"Addr1": "28 Shivaji Marg","Addr2": "28 Shivaji Marg","Loc": "","Pin": 302005,"Stcd": "08"},"ItemList": [{"Slno": "1","PrdDesc": "Test material -1",' &&
    '"IsServc": "N","Hsncd": "85011020","Barcde": "","Qty": 2.000,"FreeQty": 0,"Unit": "NOS","UnitPrice": 2000000.00,"TotAmt": 4000000.00,"Discount": 0.00,' &&
    '"PreTaxVal": 0,"AssAmt": 4000000.00,"GstRt": 18.000000000,"IgstAmt": 720000.00,"CgstAmt": 0.00,"SgstAmt": 0.00,"CesRt": 0,"CesAmt": 0,"CesNonAdvlAmt": 0,' &&
    '"StateCesRt": 0,"StateCesAmt": 0,"StateCesNonAdvlAmt": 0,"OthChrg": 0,"TotItemVal": 4720000.00,"OrdLineRef": "","OrgCntry": "","PrdSlNo": "",' &&
    '"BchDtls": {"Nm": "","ExpDt": "","WrDt": ""}}],' &&
    '"ValDtls": {"AssVal": 6000000.00,"CgstVal": 0.00,"SgstVal": 0.00,"IgstVal": 1080000.00,"CesVal": 0,"StCesVal": 0,"Discount": 0.00,"OthChrg": 0,"RndOffAmt": 0,"TotInvVal": 7080000.00,"TotInvValFc": 0},' &&
    '"PayDtls": {"Nm": "","AccDet": "","Mode": "","FinInsBr": "","PayTerm": "","PayInstr": "","CrTrn": "","DirDr": "","CrDay": 0,"PaidAmt": 0,"PayMtDue": 0},' &&
    '"RefDtls": {"InvRm": "","DocPerdDtls": {"InvStDt": "","InvEndDt": ""},"PrecDocDtls": [],"ContrDtls": []},' &&
    '"AddlDocDtls": [{"Url": "https://einv-apisandbox.nic.in","Docs": "","Info": ""}],' &&
    '"ExpDtls": {"ShipBno": "","ShipBdt": "","Port": "","RefClm": "","ForCur": "INR","CntCode": "","ExpDuty": "0"},' &&
    '"EwbDtls": {"TransId": "","TransName": "","Distance": "0","TransDocNo": "","TransDocDt": "","VehNo": "","VehType": "","TransMode": ""}}}'.

*iv_payload = '{"client_code":"ptmuT","user_code":"ENEXIO_DEMO","password":"Enexio@123","json_data"'&&
*':{"Version":"1.1","TranDtls":{"TaxSch":"GST","SupTyp":"B2B","RegRev":"N","EcmGstin":"","IgstOnIntra":"N"},' &&
*'"DocDtls":{"Typ":"INV","No":"90000056","Dt":"24/04/2026"},"SellerDtls":{"Gstin":"27AAAPI3182M002","Lglnm":'.
*
*concatenate i_payload
*'"BOC/IMPORT - DRY COOLING","Trdnm":"BOC/IMPORT - DRY COOLING","Addr1":"Avvai Shanmugam Salai, Royapettah","Addr2":"Avvai Shanmugam Salai, Royapettah","Loc":"Chennai","Pin":600018,"Stcd":"33","Ph":"","Em":""},'  '"BuyerDtls":{"Gstin":"24AAAPI3182M002","
    "Lglnm":"JINDAL URBAN WASTE MANAGEMENT (JODH PVT LTD","Trdnm":"JINDAL URBAN WASTE MANAGEMENT (JODH PVT LTD","Pos":"08","Addr1":"28 Shivaji Marg","Addr2":"28 Shivaji Marg","Loc":"","Pin":302005,"Stcd":"08","Ph":"","Em":""},' &&
*'"DispDtls":{"Nm":"","Addr1":"","Addr2":"","Loc":"","Pin":"","Stcd":""},"ShipDtls":{"Gstin":"24AAAPI3182M002","Lglnm":"JINDAL URBAN WASTE MANAGEMENT (JODH PVT LTD","Trdnm":"JINDAL URBAN WASTE MANAGEMENT (JODH PVT LTD","Addr1":"28 Shivaji Marg","Addr2":"
    "28 Shivaji Marg","Loc":"","Pin":302005,"Stcd":"08"},' &&
*'"ItemList":[{"Slno":"1","PrdDesc":"Test material -1","IsServc":"N","Hsncd":"85011020","Barcde":"","Qty":2.000,"FreeQty":0,"Unit":"NOS","UnitPrice":2000000.00,"TotAmt":4000000.00,"Discount":0.00,"PreTaxVal":0,"AssAmt":4000000.00,"GstRt":18.000000000,"Ig
 "stAmt":720000.00,"CgstAmt":0.00,"SgstAmt":0.00,"CesRt":0,"CesAmt":0,"CesNonAdvlAmt":0,"StateCesRt":0,"StateCesAmt":0,"StateCesNonAdvlAmt":0,"OthChrg":0,"TotItemVal":4720000.00,"OrdLineRef":"","OrgCntry":"","PrdSlNo":"","BchDtls":{"Nm":"","ExpDt":"","WrD
 "t":""}},{"Slno":"2","PrdDesc":"Test material -1","IsServc":"N","Hsncd":"85011020","Barcde":"","Qty":1.000,"FreeQty":0,"Unit":"NOS","UnitPrice":2000000.00,"TotAmt":2000000.00,"Discount":0.00,"PreTaxVal":0,"AssAmt":2000000.00,"GstRt":18.000000000,"IgstAmt
 "":360000.00,"CgstAmt":0.00,"SgstAmt":0.00,"CesRt":0,"CesAmt":0,"CesNonAdvlAmt":0,"StateCesRt":0,"StateCesAmt":0,"StateCesNonAdvlAmt":0,"OthChrg":0,"TotItemVal":2360000.00,"OrdLineRef":"","OrgCntry":"","PrdSlNo":"","BchDtls":{"Nm":"","ExpDt":"","WrDt":""
 "}}],"ValDtls":{"AssVal":6000000.00,"CgstVal":0.00,"SgstVal":0.00,"IgstVal":1080000.00,"CesVal":0,"StCesVal":0,"Discount":0.00,"OthChrg":0,"RndOffAmt":0,"TotInvVal":7080000.00,"TotInvValFc":0},"PayDtls":{"Nm":"","AccDet":"","Mode":"","FinInsBr":"","PayTe
 "rm":"","PayInstr":"","CrTrn":"","DirDr":"","CrDay":0,"PaidAmt":0,"PayMtDue":0},"RefDtls":{"InvRm":"","DocPerdDtls":{"InvStDt":"","InvEndDt":""},"PrecDocDtls":[],"ContrDtls":[]},"AddlDocDtls":[{"Url":"https://einv-apisandbox.nic.in","Docs":"","Info":""}]
    ","ExpDtls":{"ShipBno":"","ShipBdt":"","Port":"","RefClm":"","ForCur":"INR","CntCode":"","ExpDuty":"0"},"EwbDtls":{"TransId":"","TransName":"","Distance":"0","TransDocNo":"","TransDocDt":"","VehNo":"","VehType":"","TransMode":""}}}'.
    DATA(lo_http_destination) =
     cl_http_destination_provider=>create_by_url( 'https://uat-api.logitax.in/einvext/v1/GenerateJSONEInvoice' ).

    DATA(lo_web_http_client) = cl_web_http_client_manager=>create_by_http_destination( lo_http_destination ) .
    DATA(lo_web_http_request) = lo_web_http_client->get_http_request( ).

**Payload

    lo_web_http_client = cl_web_http_client_manager=>create_by_http_destination( lo_http_destination ) .

    lo_web_http_request = lo_web_http_client->get_http_request( ).


*    IF iv_etag IS INITIAL.
*      lo_web_http_request->set_header_fields( VALUE #(
*                      (  name = 'x-csrf-token' value = lv_csrf )
*                      (  name = 'config_authType' value = 'Basic' )
*                      (  name = 'config_packageName' value = 'SAPS4HANACloud' )
*                      (  name = 'Accept' value = 'application/json' )
*                      (  name = 'Content-type' value = 'application/json' ) ) ).
*    ELSE.
*      lo_web_http_request->set_header_fields( VALUE #(
*                      (  name = 'x-csrf-token' value = lv_csrf )
*                      (  name = 'config_authType' value = 'Basic' )
*                      (  name = 'If-Match' value = iv_etag )
*                      (  name = 'config_packageName' value = 'SAPS4HANACloud' )
*                      (  name = 'Accept' value = 'application/json' )
*                      (  name = 'Content-type' value = 'application/json' ) ) ).
*    ENDIF.


    lo_web_http_request->set_text(
                             EXPORTING
                             i_text   = lv_payload  ).
    DATA(lo_web_http_response_post) = lo_web_http_client->execute( if_web_http_client=>post ).

    DATA(lv_response_post) = lo_web_http_response_post->get_text( ).

    DATA(lv_response_status) = lo_web_http_response_post->get_status( ).

    rv_response = lv_response_post.


  ENDMETHOD.
ENDCLASS.
