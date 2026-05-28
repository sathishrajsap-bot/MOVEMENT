CLASS lhc_ZI_RESPONSE DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_response RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR zi_response RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE zi_response.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zi_response.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE zi_response.

    METHODS read FOR READ
      IMPORTING keys FOR READ zi_response RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zi_response.

ENDCLASS.

CLASS lhc_ZI_RESPONSE IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD create.
    DATA: ls_response TYPE zdb_einv_resp,
          lt_response TYPE STANDARD TABLE OF zdb_einv_resp.

    TYPES:
      BEGIN OF ty_attribdtls,
        nm  TYPE string,
        val TYPE string,
      END OF ty_attribdtls,

      BEGIN OF ty_bchdtls,
        nm    TYPE string,
        expdt TYPE string,
        wrdt  TYPE string,
      END OF ty_bchdtls,

      BEGIN OF ty_itemlist,
        slno               TYPE string,
        prddesc            TYPE string,
        isservc            TYPE string,
        hsncd              TYPE string,
        barcde             TYPE string,
        qty                TYPE string,
        freeqty            TYPE string,
        unit               TYPE string,
        unitprice          TYPE string,
        totamt             TYPE string,
        discount           TYPE string,
        pretaxval          TYPE string,
        assamt             TYPE string,
        gstrt              TYPE string,
        igstamt            TYPE string,
        cgstamt            TYPE string,
        sgstamt            TYPE string,
        cesrt              TYPE string,
        cesamt             TYPE string,
        cesnonadvlamt      TYPE string,
        statecesrt         TYPE string,
        statecesamt        TYPE string,
        statecesnonadvlamt TYPE string,
        othchrg            TYPE string,
        totitemval         TYPE string,
        ordlineref         TYPE string,
        orgcntry           TYPE string,
        prdslno            TYPE string,
        bchdtls            TYPE ty_bchdtls,
        "   lt_bchdtls    TYPE TABLE OF ty_bchdtls WITH  EMPTY KEY,
      END OF ty_itemlist,

      BEGIN OF ty_valdtls,
        assval      TYPE string,
        cgstval     TYPE string,
        sgstval     TYPE string,
        igstval     TYPE string,
        cesval      TYPE string,
        stcesval    TYPE string,
        discount    TYPE string,
        othchrg     TYPE string,
        rndoffamt   TYPE string,
        totinvval   TYPE string,
        totinvvalfc TYPE string,
      END OF ty_valdtls,

      BEGIN OF ty_docdtls,
        typ TYPE string,
        no  TYPE string,
        dt  TYPE string,
      END OF ty_docdtls,

      BEGIN OF ty_sellerdtls,
        gstin TYPE string,
        lglnm TYPE string,
        trdnm TYPE string,
        addr1 TYPE string,
        addr2 TYPE string,
        loc   TYPE string,
        pin   TYPE string,
        stcd  TYPE string,
        ph    TYPE string,
        em    TYPE string,
      END OF ty_sellerdtls,

      BEGIN OF ty_buyerdtls,
        gstin TYPE string,
        lglnm TYPE string,
        trdnm TYPE string,
        pos   TYPE string,
        addr1 TYPE string,
        addr2 TYPE string,
        loc   TYPE string,
        pin   TYPE string,
        stcd  TYPE string,
        ph    TYPE string,
        em    TYPE string,
      END OF ty_buyerdtls,

      BEGIN OF ty_dispdtls,
        nm    TYPE string,
        addr1 TYPE string,
        addr2 TYPE string,
        loc   TYPE string,
        pin   TYPE string,
        stcd  TYPE string,
      END OF ty_dispdtls,

      BEGIN OF ty_shipdtls,
        gstin TYPE string,
        lglnm TYPE string,
        trdnm TYPE string,
        addr1 TYPE string,
        addr2 TYPE string,
        loc   TYPE string,
        pin   TYPE string,
        stcd  TYPE string,
      END OF ty_shipdtls.

    TYPES : BEGIN OF docperddtls,
              invstdt  TYPE string,
              invenddt TYPE string,
            END OF docperddtls.
    TYPES  : BEGIN OF precdocdtls,
               invno    TYPE string,
               invdt    TYPE string,
               othrefno TYPE string,
             END OF precdocdtls.

    TYPES : BEGIN OF contrdtls,
              recadvrefr TYPE string,
              recadvdt   TYPE string,
              tendrefr   TYPE string,
              contrrefr  TYPE string,
              extrefr    TYPE string,
              projrefr   TYPE string,
              porefr     TYPE string,
              porefdt    TYPE string,
            END OF contrdtls.

    TYPES : BEGIN OF ty_refdtls,
              invrm       TYPE string,
              docperddtls TYPE docperddtls,
              precdocdtls TYPE TABLE OF precdocdtls WITH EMPTY KEY,
              contrdtls   TYPE TABLE OF contrdtls WITH EMPTY KEY,
            END OF ty_refdtls,

            BEGIN OF ty_addldocdtls,
              url  TYPE string,
              docs TYPE string,
              info TYPE string,
            END OF ty_addldocdtls,

            BEGIN OF ty_ewbdtls,
              transid    TYPE string,
              transname  TYPE string,
              distance   TYPE string,
              transdocno TYPE string,
              transdocdt TYPE string,
              vehno      TYPE string,
              vehtype    TYPE string,
              transmode  TYPE string,
            END OF ty_ewbdtls,

            BEGIN OF trandtls,
              taxsch      TYPE string,
              suptyp      TYPE string,
              regrev      TYPE string,
              ecmgstin    TYPE string,
              igstonintra TYPE string,
            END OF trandtls,
            BEGIN OF paydtls,
              nm       TYPE string,
              accdet   TYPE string,
              mode     TYPE string,
              fininsbr TYPE string,
              payterm  TYPE string,
              payinstr TYPE string,
              crtrn    TYPE string,
              dirdr    TYPE string,
              crday    TYPE string,
              paidamt  TYPE string,
              paymtdue TYPE string,
            END OF paydtls,

            BEGIN OF expdtls,
              shipbno TYPE string,
              shipbdt TYPE string,
              port    TYPE string,
              refclm  TYPE string,
              forcur  TYPE string,
              cntcode TYPE string,
              expduty TYPE string,
            END OF expdtls.


    DATA: ls_item TYPE ty_itemlist.
    DATA: sno            TYPE i,
          lv_tot_cessamt TYPE  n LENGTH 16,
          lv_in          TYPE string,
          rv_out         TYPE string,
          lv_date        TYPE char10,
          lv_eway_date   TYPE string,
          lv_eway_date1  TYPE string,
          lv_eway_vali   TYPE string,
          lv_eway_vali1  TYPE string,
          lv_url         TYPE string.


**************************************JSON 1.
    TYPES : BEGIN OF ty_json ,
              version     TYPE string,
              trandtls    TYPE trandtls,
              docdtls     TYPE ty_docdtls,
              sellerdtls  TYPE ty_sellerdtls,
              buyerdtls   TYPE ty_buyerdtls,
              dispdtls    TYPE ty_dispdtls,
              shipdtls    TYPE ty_shipdtls,
              itemlist    TYPE TABLE OF ty_itemlist WITH EMPTY KEY,
              valdtls     TYPE ty_valdtls,
              paydtls     TYPE paydtls,
              refdtls     TYPE ty_refdtls,
              addldocdtls TYPE TABLE OF ty_addldocdtls WITH EMPTY KEY,
              expdtls     TYPE expdtls,
              ewbdtls     TYPE ty_ewbdtls,
            END OF ty_json.


*********************************

    TYPES : BEGIN OF ty_json_data,
              client_code TYPE string,
              user_code   TYPE string,
              password    TYPE string,
              json_data   TYPE  ty_json,

            END OF ty_json_data.




    DATA: lv_gstrt TYPE p DECIMALS 0.

    DATA: gv_json_data  TYPE ty_json_data,
          lv_jsonstatus TYPE string.

    DATA : ls_addldocdtls TYPE ty_addldocdtls.

    TYPES : BEGIN OF ty_str,  "response strucure
              flag              TYPE string,
              message           TYPE string,
              docno             TYPE string,
              docdate           TYPE string,
              ackno             TYPE string,
              ackdt             TYPE string,
              irn               TYPE string,
              signedinvoice     TYPE string,
              signedqrcode      TYPE string,
              status            TYPE string,
              dcrysignedinvoice TYPE string,
              dcrysignedqrcode  TYPE string,
              error_log_ids     TYPE string,
              ewbno             TYPE string,
              ewbdt             TYPE string,
              ewbvalidtill      TYPE string,
              pdfurl            TYPE string,
              pdfeinvurl        TYPE string,
              detailedpdfurl    TYPE string,
              infodtls          TYPE string,
              doctype           TYPE string,
            END OF ty_str.

    DATA : lt_res TYPE TABLE OF ty_str,
           ls_res TYPE ty_str.

*    READ TABLE entities ASSIGNING FIELD-SYMBOL(<fs_entity>) INDEX 1.
*    <fs_entity>-documentno = |{ <fs_entity>-documentno ALPHA = IN }|.
    SELECT * FROM zi_billing_header FOR ALL ENTRIES IN @entities WHERE BillingDoc = @entities-documentno INTO TABLE @DATA(lt_final).

    SELECT * FROM zi_billing_item FOR ALL ENTRIES IN @entities WHERE BillingDoc = @entities-documentno INTO TABLE @DATA(lt_vbrp).

    LOOP AT entities INTO DATA(ls_entity).

      READ TABLE lt_final INTO DATA(ls_final) WITH KEY BillingDoc = ls_entity-documentno.

      IF sy-sysid = 'DUW'.
        gv_json_data-client_code = 'ptmuT'.
        gv_json_data-user_code = 'ENEXIO_DEMO'.
        gv_json_data-password  = 'Enexio@123'.
        lv_url = 'https://uat-api.logitax.in/einvext/v1/GenerateJSONEInvoice'.
      ELSE.
*          gv_json_data-client_code = 'RfMG9'.
*          gv_json_data-password  = 'Besmak@123'.
*          gv_json_data-user_code = 'Besmak_Admin'.
      ENDIF.

      "Version
      gv_json_data-json_data-version = '1.03'.

      "Transdtls
      gv_json_data-json_data-trandtls-taxsch = 'GST'.
*      gv_json_data-json_data-trandtls-suptyp = 'B2B'.
      gv_json_data-json_data-trandtls-regrev = 'N'.
      gv_json_data-json_data-trandtls-igstonintra = 'N'.
      gv_json_data-json_data-trandtls-ecmgstin = ''.
      gv_json_data-json_data-trandtls-IgstOnIntra = 'N'.

      "Docdtls
      gv_json_data-json_data-docdtls-no = |{ ls_final-BillingDoc ALPHA = OUT }|.
      CONDENSE gv_json_data-json_data-docdtls-no NO-GAPS.
      CONCATENATE ls_final-Dt+6(2) '/' ls_final-Dt+4(2) '/' ls_final-Dt+0(4) INTO lv_date.
      gv_json_data-json_data-docdtls-dt = lv_date.
      gv_json_data-json_data-docdtls-typ = ls_final-BillingType.

      "Sellerdtls
      gv_json_data-json_data-sellerdtls-gstin = '27AAAPI3182M002'."ls_final-SellerGst.

      gv_json_data-json_data-sellerdtls-lglnm = ls_final-SellerName.
      gv_json_data-json_data-sellerdtls-trdnm = ls_final-SellerName.
      gv_json_data-json_data-sellerdtls-addr1 = |{ ls_final-SellerStreetName } { ls_final-SellerStreet }|.
      gv_json_data-json_data-sellerdtls-loc = ls_final-SellerCityName.
      gv_json_data-json_data-sellerdtls-stcd = ls_final-SellerStateCode.
      gv_json_data-json_data-sellerdtls-pin  = ls_final-SellerPostalCode.

      "Buyerdtls
      gv_json_data-json_data-buyerdtls-gstin = ls_final-BuyerGSTIN.
      gv_json_data-json_data-buyerdtls-lglnm = ls_final-BuyerName.
      gv_json_data-json_data-buyerdtls-trdnm = ls_final-BuyerName.
      gv_json_data-json_data-buyerdtls-addr1 = ls_final-BuyerStreet.
      gv_json_data-json_data-buyerdtls-loc = ls_final-BuyerCityName.
      gv_json_data-json_data-buyerdtls-pin = ls_final-BuyerPostalCode.
*      gv_json_data-json_data-buyerdtls-stcd = gv_json_data-json_data-buyerdtls-gstin+0(2).
*      gv_json_data-json_data-buyerdtls-pos = gv_json_data-json_data-buyerdtls-gstin+0(2).
      gv_json_data-json_data-buyerdtls-stcd = ls_final-BuyerGSTStateCode.
      gv_json_data-json_data-buyerdtls-pos = ls_final-BuyerGSTStateCode.

      "ShiptoParty
      IF ls_final-DistributionChannel <> '20'.
        gv_json_data-json_data-shipdtls-gstin = ls_final-ShipGSTIN.
        gv_json_data-json_data-shipdtls-lglnm = ls_final-ShipName.
        gv_json_data-json_data-shipdtls-trdnm = ls_final-ShipName.
        gv_json_data-json_data-shipdtls-pin = ls_final-ShipPostalCode.
        gv_json_data-json_data-shipdtls-stcd = gv_json_data-json_data-shipdtls-gstin+0(2).
        gv_json_data-json_data-shipdtls-addr1 = ls_final-ShipStreet.
        gv_json_data-json_data-shipdtls-loc = ls_final-ShipToCityName.
      ENDIF.

      "dispatcher details.
      IF gv_json_data-json_data-docdtls-typ  = gv_json_data-json_data-shipdtls-gstin.
        gv_json_data-json_data-dispdtls-nm = ls_final-SellerName.
        gv_json_data-json_data-dispdtls-addr1 = gv_json_data-json_data-sellerdtls-addr1.
        gv_json_data-json_data-dispdtls-loc = ls_final-SellerCityName.
*          gv_json_data-json_data-dispdtls-stcd  = ls_addsal-region.
        gv_json_data-json_data-dispdtls-stcd  = ls_final-SellerGst+0(2).
        gv_json_data-json_data-dispdtls-pin  = ls_final-SellerPostalCode.
      ENDIF.

      "ItemDetails
      LOOP AT lt_vbrp INTO DATA(ls_vbrp) WHERE BillingDoc = ls_final-BillingDoc.
        ls_item-slno = ls_vbrp-BillingDocItem.
        ls_item-prddesc = ls_vbrp-PrdDesc.
        ls_item-qty = ls_vbrp-BillingQuantity.
*        ls_item-totamt = ls_vbrp-UnitPrice * ls_item-qty.
        ls_item-totamt = ls_vbrp-TotAmt + ls_vbrp-Packaging + ls_vbrp-Insurance + ls_vbrp-freight.

        IF ls_vbrp-PrdDesc IS NOT INITIAL.
          ls_item-isservc = 'N'.
        ELSE.
          ls_item-isservc = 'Y'.
        ENDIF.

        ls_item-hsncd = ls_vbrp-Hsncd.

        IF ls_vbrp-BillingQuantityUnit EQ 'KG' OR ls_vbrp-BillingQuantityUnit EQ 'KGS' OR ls_vbrp-BillingQuantityUnit = 'KGM'.
          ls_item-unit = 'KGS'.
        ELSEIF ls_vbrp-BillingQuantityUnit EQ 'NO' OR ls_vbrp-BillingQuantityUnit EQ 'NOS' OR ls_vbrp-BillingQuantityUnit EQ 'EA' .
          ls_item-unit = 'NOS'.
        ELSEIF ls_vbrp-BillingQuantityUnit EQ 'BOX' .
          ls_item-unit = 'BOX'.
        ELSEIF ls_vbrp-BillingQuantityUnit EQ 'L' OR ls_vbrp-BillingQuantityUnit EQ 'KLR' .
          ls_item-unit = 'KLR'.
        ELSEIF ls_vbrp-BillingQuantityUnit EQ 'M' OR ls_vbrp-BillingQuantityUnit EQ 'MTR' .
          ls_item-unit = 'MTR'.
        ELSEIF ls_vbrp-BillingQuantityUnit EQ 'ROL'  .
          ls_item-unit = 'ROL'.
        ELSEIF ls_vbrp-BillingQuantityUnit EQ 'PAC'  .
          ls_item-unit = 'PAC'.
        ELSEIF ls_vbrp-BillingQuantityUnit EQ 'PC' OR ls_vbrp-BillingQuantityUnit EQ 'PCS' .
          ls_item-unit = 'PCS'.
        ELSEIF ls_vbrp-BillingQuantityUnit EQ 'SET'  .
          ls_item-unit = 'SET'.
        ELSEIF ls_vbrp-BillingQuantityUnit EQ 'ML' OR ls_vbrp-BillingQuantityUnit EQ 'MLT' .
          ls_item-unit = 'MLT'.
        ELSEIF ls_vbrp-BillingQuantityUnit EQ 'G' OR ls_vbrp-BillingQuantityUnit EQ 'GMS' .
          ls_item-unit = 'GMS'.
        ENDIF.

*        ls_item-unitprice = ls_vbrp-UnitPrice.
        ls_item-unitprice = ls_item-totamt / ls_item-qty.
        ls_item-sgstamt =  ls_vbrp-SGSTValue.
        ls_item-cgstamt = ls_vbrp-CGSTValue.
        ls_item-igstamt = ls_vbrp-IGSTValue.
        lv_gstrt = ls_vbrp-CGSTRate + ls_vbrp-SGSTRate + ls_vbrp-IGSTRate.
        ls_item-gstrt = lv_gstrt.
        CLEAR: lv_gstrt.
        ls_item-discount = ls_vbrp-Discount.
        gv_json_data-json_data-valdtls-cgstval += ls_item-cgstamt.
        gv_json_data-json_data-valdtls-sgstval += ls_item-sgstamt.
        gv_json_data-json_data-valdtls-igstval += ls_item-igstamt.

        ls_item-assamt = ls_item-totamt - ls_item-discount.
        gv_json_data-json_data-valdtls-assval += ls_item-assamt.
        ls_item-totitemval = ls_item-assamt + ls_item-igstamt + ls_item-cgstamt + ls_item-sgstamt." - ls_item-discount.
        gv_json_data-json_data-valdtls-totinvval += ls_item-totitemval.
        ls_addldocdtls-url = 'https://einv-apisandbox.nic.in'.

        APPEND ls_item TO gv_json_data-json_data-itemlist.
        APPEND ls_addldocdtls TO gv_json_data-json_data-addldocdtls.

        CLEAR: ls_vbrp, ls_item.
      ENDLOOP.

      IF gv_json_data-json_data-valdtls-igstval > 0 AND  gv_json_data-json_data-buyerdtls-gstin = 'URP'.
        gv_json_data-json_data-trandtls-suptyp = 'EXPWP'.
      ELSEIF gv_json_data-json_data-valdtls-igstval = 0 AND  gv_json_data-json_data-buyerdtls-gstin = 'URP'.
        gv_json_data-json_data-trandtls-suptyp = 'EXPWOP'.
      ELSE.
        gv_json_data-json_data-trandtls-suptyp = 'B2B'.
      ENDIF.
      IF ls_final-DistributionChannel = '20'.
        gv_json_data-json_data-expdtls-cntcode = 'TH'.
      ENDIF.
      gv_json_data-json_data-ewbdtls-distance = 0.
      gv_json_data-json_data-ewbdtls-TransId = ls_final-TransId.
      gv_json_data-json_data-ewbdtls-TransName = ls_final-TransName.
      gv_json_data-json_data-ewbdtls-TransDocNo = ''.
      gv_json_data-json_data-ewbdtls-TransDocDt = ''.
      gv_json_data-json_data-ewbdtls-VehNo = ls_final-VehNo.
      CASE ls_final-VehType.
        WHEN 'R'.
          gv_json_data-json_data-ewbdtls-VehType = ls_final-VehType.
        WHEN 'O'.
          gv_json_data-json_data-ewbdtls-VehType = ls_final-VehType.
      ENDCASE.
      "Error validation for Vehicle Type
      IF  gv_json_data-json_data-ewbdtls-TransName IS NOT INITIAL
      AND  gv_json_data-json_data-ewbdtls-TransId IS NOT INITIAL
      AND gv_json_data-json_data-ewbdtls-VehNo IS NOT INITIAL
      AND gv_json_data-json_data-ewbdtls-VehType IS INITIAL.
        DATA(lv_vehtype) = 'Vehicle type is not maintained'.
        DATA(lv_indicator) = 'X'.
      ENDIF.
      """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
      gv_json_data-json_data-ewbdtls-TransMode = '1'.
*gv_json_data-json_data-expdtls-cntcode = ls_final-ship.

      DATA(lo_json) = NEW /ui2/cl_json( ).
      lv_jsonstatus = lo_json->serialize( data = gv_json_data ).

      lv_in = lv_jsonstatus.

      DATA: lo_http_client TYPE REF TO if_web_http_client.

*      DATA(lv_payload) = '{"client_code": "ptmuT","user_code": "ENEXIO_DEMO","password": "Enexio@123","json_data": {"Version": "1.1","TranDtls": {' &&
*      '"TaxSch": "GST","SupTyp": "B2B","RegRev": "N","EcmGstin": "","IgstOnIntra": "N"},"DocDtls": {"Typ": "INV","No": "90000056","Dt": "24/04/2026"},' &&
*      '"SellerDtls": {"Gstin": "27AAAPI3182M002","Lglnm": "BOC/IMPORT - DRY COOLING","Trdnm": "BOC/IMPORT - DRY COOLING","Addr1": "Avvai Shanmugam Salai, Royapettah",' &&
*      '"Addr2": "Avvai Shanmugam Salai, Royapettah","Loc": "Chennai","Pin": 600018,"Stcd": "33","Ph": "","Em": ""},"BuyerDtls": {"Gstin": "24AAAPI3182M002",' &&
*      '"Lglnm": "JINDAL URBAN WASTE MANAGEMENT (JODH PVT LTD","Trdnm": "JINDAL URBAN WASTE MANAGEMENT (JODH PVT LTD",' && '"Pos": "08","Addr1": "28 Shivaji Marg",' &&
*      '"Addr2": "28 Shivaji Marg","Loc": "","Pin": 302005,"Stcd": "08","Ph": "","Em": ""},"DispDtls": {"Nm": "","Addr1": "","Addr2": "","Loc": "","Pin": "","Stcd": ""' &&
*      '},"ShipDtls": {"Gstin": "24AAAPI3182M002","Lglnm": "JINDAL URBAN WASTE MANAGEMENT (JODH PVT LTD","Trdnm": "JINDAL URBAN WASTE MANAGEMENT (JODH PVT LTD",' &&
*      '"Addr1": "28 Shivaji Marg","Addr2": "28 Shivaji Marg","Loc": "","Pin": 302005,"Stcd": "08"},"ItemList": [{"Slno": "1","PrdDesc": "Test material -1",' &&
*      '"IsServc": "N","Hsncd": "85011020","Barcde": "","Qty": 2.000,"FreeQty": 0,"Unit": "NOS","UnitPrice": 2000000.00,"TotAmt": 4000000.00,"Discount": 0.00,' &&
*      '"PreTaxVal": 0,"AssAmt": 4000000.00,"GstRt": 18.000000000,"IgstAmt": 720000.00,"CgstAmt": 0.00,"SgstAmt": 0.00,"CesRt": 0,"CesAmt": 0,"CesNonAdvlAmt": 0,' &&
*      '"StateCesRt": 0,"StateCesAmt": 0,"StateCesNonAdvlAmt": 0,"OthChrg": 0,"TotItemVal": 4720000.00,"OrdLineRef": "","OrgCntry": "","PrdSlNo": "",' &&
*      '"BchDtls": {"Nm": "","ExpDt": "","WrDt": ""}}],' &&
*      '"ValDtls": {"AssVal": 6000000.00,"CgstVal": 0.00,"SgstVal": 0.00,"IgstVal": 1080000.00,"CesVal": 0,"StCesVal": 0,"Discount": 0.00,"OthChrg": 0,"RndOffAmt": 0,"TotInvVal": 7080000.00,"TotInvValFc": 0},' &&
*      '"PayDtls": {"Nm": "","AccDet": "","Mode": "","FinInsBr": "","PayTerm": "","PayInstr": "","CrTrn": "","DirDr": "","CrDay": 0,"PaidAmt": 0,"PayMtDue": 0},' &&
*      '"RefDtls": {"InvRm": "","DocPerdDtls": {"InvStDt": "","InvEndDt": ""},"PrecDocDtls": [],"ContrDtls": []},' &&
*      '"AddlDocDtls": [{"Url": "https://einv-apisandbox.nic.in","Docs": "","Info": ""}],' &&
*      '"ExpDtls": {"ShipBno": "","ShipBdt": "","Port": "","RefClm": "","ForCur": "INR","CntCode": "","ExpDuty": "0"},' &&
*      '"EwbDtls": {"TransId": "","TransName": "","Distance": "0","TransDocNo": "","TransDocDt": "","VehNo": "","VehType": "","TransMode": ""}}}'.
      IF lv_indicator <> 'X'.
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
        REPLACE ALL OCCURRENCES OF 'true' IN lv_response_post WITH '"true"'.
        REPLACE ALL OCCURRENCES OF '"flag":false' IN lv_response_post WITH '"flag":"false"'.
        REPLACE ALL OCCURRENCES OF 'null' IN lv_response_post WITH '"null"'.

        /ui2/cl_json=>deserialize( EXPORTING json         = lv_response_post
                                    pretty_name  = /ui2/cl_json=>pretty_mode-camel_case
                                   CHANGING  data         = lt_res ).
      ENDIF.

      READ TABLE lt_res INTO ls_res INDEX 1.

      IF ls_res-flag = 'true'.

        ls_response-docno = |{ ls_res-docno ALPHA = IN }|.
        ls_response-ackdate = ls_res-ackdt.
        ls_response-ackno = ls_res-Ackno.
        ls_response-dcrysignedinvoice = ls_res-Dcrysignedinvoice.
        ls_response-dcrysignedqrcode = ls_res-Dcrysignedqrcode.
        ls_response-Detailedpdfurl = ls_res-Detailedpdfurl.
        ls_response-docdate = ls_res-docdate.
        ls_response-doctype = ls_res-doctype.
        ls_response-error_log_ids = ls_res-error_log_ids.
        ls_response-ewbdt = ls_res-ewbdt.
        ls_response-ewbno = ls_res-ewbno.
        ls_response-ewbvalidtill = ls_res-ewbvalidtill.
        ls_response-infodtls = ls_res-infodtls.
        ls_response-irn = ls_res-irn.
        ls_response-message = ls_res-message.
        ls_response-pdfeinvurl = ls_res-pdfeinvurl.
        ls_response-pdfurl = ls_res-pdfurl.
        ls_response-signedinvoice = ls_res-signedinvoice.
        ls_response-signedqrcode = ls_res-signedqrcode.
        ls_response-status = 'Generated'.
        ls_response-createdby = sy-uname.
        ls_response-createddt = sy-datum.
        ls_response-createdtime = sy-uzeit.
        ls_response-json = lv_in.
        APPEND ls_response TO lt_response.
        MODIFY zdb_einv_resp FROM TABLE @lt_response.

      ENDIF.
      IF lv_indicator = 'X'.
        ls_res-message = lv_vehtype.
      ENDIF.

      APPEND VALUE #(
                    %cid = ls_entity-%cid
                    documentno = ls_entity-documentno
                    message = ls_res-message
                    irn = ls_res-irn
                    ewbno = ls_res-ewbno
                    ewbdt = ls_res-ewbdt
                    ackno = ls_res-ackno
                    ackdate = ls_res-ackdt
                    createdby = sy-uname
                    createddt = sy-datum
                    createdtime = sy-uzeit
                    pdfurl = ls_res-pdfurl
                    detailedpdfurl = ls_res-detailedpdfurl
                    )
                    TO mapped-zi_response.

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

CLASS lsc_ZI_RESPONSE DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZI_RESPONSE IMPLEMENTATION.

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
