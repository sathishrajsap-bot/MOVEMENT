@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZP01 CONDITION TYPE'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_ZP01
  as select from I_BillingDocumentItemPrcgElmnt
  //composition of target_data_source_name as _association_name
{
  key _Item.BillingDocument     as BillingDoc,
  key _Item.BillingDocumentItem as BillingDocItem,
      ConditionRateValue        as UnitPrice,
      TransactionCurrency,
      @DefaultAggregation: #NONE
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      ConditionAmount           as TotAmt

      //  _association_name // Make association public
}
where
  ConditionType = 'ZP01'
