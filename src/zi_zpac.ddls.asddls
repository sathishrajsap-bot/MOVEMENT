@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZPAC CONDITION TYPE'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_ZPAC
  as select from I_BillingDocumentItemPrcgElmnt
  //composition of target_data_source_name as _association_name
{
  key _Item.BillingDocument     as BillingDoc,
  key _Item.BillingDocumentItem as BillingDocItem,
      ConditionRateValue,
      TransactionCurrency,
      @DefaultAggregation: #NONE
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      ConditionAmount           as Packaging

      //  _association_name // Make association public
}
where
  ConditionType = 'ZPAC'
