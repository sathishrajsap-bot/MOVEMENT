@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Generate E-Way Interface'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_GEN_EWAY
  as select from zdb_einv_resp     as _db
    inner join   I_BillingDocument as _Billing on _db.docno = _Billing.BillingDocument
    inner join   I_Customer        as _Cust    on _Billing.SoldToParty = _Cust.Customer
  //composition of target_data_source_name as _association_name
{
  key _db.docno                    as BillingDocument,
      // flag              as Flag,
      _Billing.BillingDocumentDate as CreationDate,
      _db.ackno                    as ackno,
      _db.ackdate                  as ackdate,
      _db.message                  as message,
      _db.irn                      as irn,
      //      signedinvoice     as Signedinvoice,
      //      signedqrcode      as Signedqrcode,
      //      status            as Status,
      //      dcrysignedinvoice as Dcrysignedinvoice,
      //      dcrysignedqrcode  as Dcrysignedqrcode,
      //      error_log_ids     as ErrorLogIds,
      _db.ewbno                    as ewbno,
      _db.ewbdt                    as ewbdt,
      //      ewbvalidtill   as Ewbvalidtill,
      _db.pdfurl                   as pdfurl,
      _db.detailedpdfurl           as detailedpdfurl,
      _Billing.SoldToParty,
      _Cust.CustomerName
      //      infodtls          as Infodtls,
      //      doctype           as Doctype,
      //      pdfeinvurl        as Pdfeinvurl,
      //      createdby         as Createdby,
      //      createddt         as Createddt,
      //      createdtime       as Createdtime
      // json              as Json

      //   _association_name // Make association public
}
