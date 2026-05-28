@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'E-Way Post with IRN'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_EWAY_POST
  as select from zdb_einvoice
  //  composition of target_data_source_name as _association_name
{
      //  key docno          as Docno,
      //  key documentno     as documentno,
      //  key message        as Message,
      //  key irn            as Irn,
      //  key ewbno          as Ewbno,
      //  key ewbdt          as Ewbdt,
      //  key ackno          as Ackno,
      //  key ackdate        as Ackdate,
      //  key createdby      as Createdby,
      //  key createddt      as Createddt,
      //  key createdtime    as Createdtime,
      //  key pdfurl         as Pdfurl,
      //  key detailedpdfurl as Detailedpdfurl

  key docno as Docno,
  key documentno,
  key status,
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
      //_association_name // Make association public
}
