@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Generate E-Way Projection'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZC_EWAY_POST
  provider contract transactional_query
  as projection on ZI_EWAY_POST
{
        //  key Docno,
        //  key documentno,
        //  key Message,
        //  key Irn,
        //  key Ewbno,
        //  key Ewbdt,
        //  key Ackno,
        //  key Ackdate,
        //  key Createdby,
        //  key Createddt,
        //  key Createdtime,
        //  key Pdfurl,
        //  key Detailedpdfurl

  key   Docno,
  key   documentno,
  key   status,
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
