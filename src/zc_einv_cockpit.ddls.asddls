@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'E-Invoice Cockpit'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZC_EINV_COCKPIT
  provider contract transactional_query
  as projection on ZI_EINV_COCKPIT
{
  key BillingDocument,
      BillingDocumentType,
      CreationDate,
      SoldToParty,
      CustomerName,
      status,
      message,
      irn,
      ackno,
      ackdate,
      ewbno,
      ewbdt,
      pdfurl,
      detailedpdfurl
}
