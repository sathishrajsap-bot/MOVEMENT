@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'JOCG CONDITION TYPE'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_CGST
  as select from I_BillingDocumentItemPrcgElmnt
  //composition of target_data_source_name as _association_name
{
  key _Item.BillingDocument     as BillingDoc,
  key _Item.BillingDocumentItem as BillingDocItem,
      ConditionRateValue        as CGSTRate,
      TransactionCurrency,
      @DefaultAggregation: #NONE
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      ConditionAmount           as CGSTValue

      //  _association_name // Make association public
}
where
  ConditionType = 'JOCG'
