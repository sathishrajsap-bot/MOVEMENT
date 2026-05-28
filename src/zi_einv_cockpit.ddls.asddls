@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'E-Invoice Cockpit'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_EINV_COCKPIT
  as select from    I_BillingDocument as _Header
    left outer join I_Customer        as _Cust     on _Header.SoldToParty = _Cust.Customer

  //left outer join       I_BillingDocumentPrcgElmnt as _Bill     on _Bill.BillingDocument = _Header.BillingDocument

    left outer join zdb_einv_resp     as _Response on _Response.docno = _Header.BillingDocument

  //composition of target_data_source_name as _association_name
{
  key _Header.BillingDocument,
      _Header.BillingDocumentType,
      _Header.BillingDocumentDate as CreationDate,
      _Header.SoldToParty,
      _Cust.CustomerName,
      _Response.status,
      _Response.message,
      _Response.irn,
      //      cast( _Response.irn as abap.char(200) ) as irn,
      _Response.ackno,
      _Response.ackdate,
      _Response.ewbno,
      _Response.ewbdt,
      _Response.pdfurl,
      _Response.pdfeinvurl        as detailedpdfurl

      //  _association_name // Make association public
}
where
  //  _Header.BillingDocumentType        = 'F2'
  //and
      _Header.BillingDocumentIsCancelled =  ''
  and _Header.BillingDocumentType        <> 'S1'
//  and _Header.CancelledBillingDocument <> ''
