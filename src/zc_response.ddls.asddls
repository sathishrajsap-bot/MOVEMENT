@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Response'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZC_RESPONSE
  provider contract transactional_query
  as projection on ZI_RESPONSE
{
        //  key DocNo,
        //      DocDate,
        //      AckNo,
        //      AckDt,
        //      message,
        //      Irn,
        //      SignedInvoice,
        //      SignedQRCode,
        //      Status,
        //      DcrySignedInvoice,
        //      DcrySignedQRCode,
        //      error_log_ids,
        //      EwbNo,
        //      EwbDt,
        //      EwbValidTill,
        //      pdfUrl,
        //      detailedpdfUrl,
        //      InfoDtls,
        //      DocType,
        //      PDFEInvurl,
        //      flag
  key   Docno,
  key   documentno,
  key   message,
  key   irn,
  key   ewbno,
  key   ewbdt,
  key   ackno,
  key   ackdate,
  key   createdby,
  key   createddt,
  key   createdtime,
  key   pdfurl,
  key   detailedpdfurl

}
