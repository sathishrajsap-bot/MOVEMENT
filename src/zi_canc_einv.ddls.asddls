@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cancel E-Invoice'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_CANC_EINV
  as select from zcanc_einv_resp
  //composition of target_data_source_name as _association_name
{
  key documentno as documentno,
  key message    as Message,
  key irn        as Irn,
  key canceldate as Canceldate,
  key canceltime as Canceltime,
  key cancelrmk  as Cancelrmk,
  key cancelrsn  as Cancelrsn
      //  _association_name // Make association public
}
