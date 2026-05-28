@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cancel Einvoice and Eway'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZC_Canc_Einv_Eway
  provider contract transactional_query
  as projection on ZI_CANC_EINV
{
  key documentno,
  key Message,
  key Irn,
  key Canceldate,
  key Canceltime,
  key Cancelrmk,
  key Cancelrsn
}
