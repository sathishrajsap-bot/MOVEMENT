@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZD01 CONDITION TYPE'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_ZD01
  as select from I_BillingDocumentItemPrcgElmnt
  //composition of target_data_source_name as _association_name
{
  key _Item.BillingDocument     as BillingDoc,
  key _Item.BillingDocumentItem as BillingDocItem,
      ConditionRateValue        ,
      TransactionCurrency,
      @DefaultAggregation: #NONE
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      ConditionAmount           as Discount

      //  _association_name // Make association public
}
where
  ConditionType = 'ZD01'
