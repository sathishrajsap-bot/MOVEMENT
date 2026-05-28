@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'BILLING ITEM'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZC_BILLIG_ITEM
  provider contract transactional_query
  as projection on ZI_BILLING_ITEM
{
  key BillingDoc,
  key BillingDocItem,
      PrdDesc,
      Hsncd,
      IsServc,
      BillingQuantityUnit,
      @Semantics.quantity.unitOfMeasure: 'BillingQuantityUnit'
      BillingQuantity,
      TransactionCurrency,
      @DefaultAggregation: #NONE
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      UnitPrice,
      @DefaultAggregation: #NONE
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      TotAmt,
      @DefaultAggregation: #NONE
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      Discount,
      @DefaultAggregation: #NONE
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      Packaging,
      @DefaultAggregation: #NONE
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      Insurance,
      @DefaultAggregation: #NONE
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      Freight,

      CGSTRate,
      SGSTRate,
      IGSTRate,
      @DefaultAggregation: #NONE
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      CGSTValue,
      @DefaultAggregation: #NONE
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      SGSTValue,
      @DefaultAggregation: #NONE
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      IGSTValue
}
