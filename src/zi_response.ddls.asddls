@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Response'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_RESPONSE
  as select from zdb_einvoice
  // composition of target_data_source_name as _association_name
{
      //  key docno             as DocNo,
      //      docdate           as DocDate,
      //      ackno             as AckNo,
      //      ackdate           as AckDt,
      //      message           as message,
      //      irn               as Irn,
      //      signedinvoice     as SignedInvoice,
      //      signedqrcode      as SignedQRCode,
      //      status            as Status,
      //      dcrysignedinvoice as DcrySignedInvoice,
      //      dcrysignedqrcode  as DcrySignedQRCode,
      //      error_log_ids     as error_log_ids,
      //      ewbno             as EwbNo,
      //      ewbdt             as EwbDt,
      //      ewbvalidtill      as EwbValidTill,
      //      pdfurl            as pdfUrl,
      //      detailedpdfurl    as detailedpdfUrl,
      //      infodtls          as InfoDtls,
      //      doctype           as DocType,
      //      pdfeinvurl        as PDFEInvurl,
      //      flag              as flag
      // _association_name // Make association public
  key docno as Docno,
  key documentno,
  key message,
  key irn,
  key ewbno,
  key ewbdt,
  key ackno,
  key ackdate,
  key createdby,
  key createddt,
  key createdtime,
  key pdfurl,
  key detailedpdfurl
}
