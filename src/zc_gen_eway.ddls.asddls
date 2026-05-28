@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Generate E-Way Projection'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZC_GEN_EWAY
  provider contract transactional_query
  as projection on ZI_GEN_EWAY
{
  key BillingDocument,
      CreationDate,
      ackno,
      ackdate,
      message,
      irn,
      ewbno,
      ewbdt,
      //      Ewbvalidtill,
      pdfurl,
      detailedpdfurl,
      SoldToParty,
      CustomerName
}
