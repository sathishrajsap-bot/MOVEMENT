@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'BILLING ITEM'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_BILLING_ITEM
  as select from    I_BillingDocumentItem as _Item
    inner join      I_ProductPlantBasic   as _hsn  on  _Item.Product = _hsn.Product
                                                   and _Item.Plant   = _hsn.Plant
    left outer join ZI_ZP01               as _ZP01 on  _Item.BillingDocument     = _ZP01.BillingDoc
                                                   and _Item.BillingDocumentItem = _ZP01.BillingDocItem
  //                                                 and _ZP01.ConditionType       = 'ZP01'
    left outer join ZI_ZD01               as _ZD01 on  _Item.BillingDocument     = _ZD01.BillingDoc
                                                   and _Item.BillingDocumentItem = _ZD01.BillingDocItem
    left outer join ZI_ZPAC               as _ZPAC on  _Item.BillingDocument     = _ZPAC.BillingDoc
                                                   and _Item.BillingDocumentItem = _ZPAC.BillingDocItem
    left outer join ZI_ZINS               as _ZINS on  _Item.BillingDocument     = _ZINS.BillingDoc
                                                   and _Item.BillingDocumentItem = _ZINS.BillingDocItem
    left outer join ZI_ZFRT               as _ZFRT on  _Item.BillingDocument     = _ZFRT.BillingDoc
                                                   and _Item.BillingDocumentItem = _ZFRT.BillingDocItem
    left outer join ZI_CGST               as _CGST on  _Item.BillingDocument     = _CGST.BillingDoc
                                                   and _Item.BillingDocumentItem = _CGST.BillingDocItem
    left outer join ZI_SGST               as _SGST on  _Item.BillingDocument     = _SGST.BillingDoc
                                                   and _Item.BillingDocumentItem = _SGST.BillingDocItem
    left outer join ZI_IGST               as _IGST on  _Item.BillingDocument     = _IGST.BillingDoc
                                                   and _Item.BillingDocumentItem = _IGST.BillingDocItem

  //composition of target_data_source_name as _association_name
{
  key _Item.BillingDocument                      as BillingDoc,
  key _Item.BillingDocumentItem                  as BillingDocItem,
      _Item.BillingDocumentItemText              as PrdDesc,
      _hsn.ConsumptionTaxCtrlCode                as Hsncd,
      case
      when
      substring( _hsn.ConsumptionTaxCtrlCode , 1, 2 ) = '99' then 'Y'
      else
      'N'
      end                                        as IsServc,
      _Item.BillingQuantityUnit,
      @Semantics.quantity.unitOfMeasure: 'BillingQuantityUnit'
      _Item.BillingQuantity,
      //_ZP01.UnitPrice               as UnitPrice,
      //cast( _ZP01.UnitPrice as abap.curr( 15, 2 )  as UnitPrice,
      _ZP01.TransactionCurrency,
      @DefaultAggregation: #NONE
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      cast( _ZP01.UnitPrice as abap.curr(15,2) ) as UnitPrice,

      @DefaultAggregation: #NONE
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      _ZP01.TotAmt                               as TotAmt,

      @DefaultAggregation: #NONE
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      (_ZD01.Discount * -1)                      as Discount,

      @DefaultAggregation: #NONE
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      _ZPAC.Packaging,
      @DefaultAggregation: #NONE
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      _ZINS.Insurance,

      @DefaultAggregation: #NONE
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      _ZFRT.Freight,

      _CGST.CGSTRate,
      _SGST.SGSTRate,
      _IGST.IGSTRate,
      @DefaultAggregation: #NONE
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      _CGST.CGSTValue,
      @DefaultAggregation: #NONE
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      _SGST.SGSTValue,
      @DefaultAggregation: #NONE
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      _IGST.IGSTValue

      //_ZD01.Discount                as Discount
      // (_ZP01.TotAmt + _ZD01.Discount + _ZPAC.Packaging + _ZINS.Insurance + _ZFRT.Freight ) as Assamt

      //    @DefaultAggregation: #NONE
      //     @Semantics.amount.currencyCode: 'TransactionCurrency'
      //( cast( _ZP01.ConditionAmount as abap.curr( 15, 2 ) ) - cast( _ZD01.ConditionAmount as abap.curr( 15, 2 ))) as Assamt

      //    ( _ZP01.ConditionAmount - _ZD01.ConditionAmount ) as Assamt



      //  _association_name // Make association public
}
where
  _Item.BillingQuantity > 0
