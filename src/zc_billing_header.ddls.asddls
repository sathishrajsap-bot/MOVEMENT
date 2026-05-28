@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'BILLING HEADER'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZC_BILLING_HEADER
  provider contract transactional_query
  as projection on ZI_BILLING_HEADER
{
  key BillingDoc,
      Dt,
      BillingType,
      DistributionChannel,
      BuyerGSTIN,
      BuyerName,
      BuyerStreet,
      BuyerRegion,
      BuyerCityName,
      BuyerPostalCode,
      BuyerGSTStateCode,
      SellerName,
      SellerGst,
      SellerStreetName,
      SellerHouseNumber,
      SellerStreet,
      SellerCityName,
      SellerPostalCode,
      SellerStateCode,
      ShipGSTIN,
      ShipName,
      ShipStreet,
      ShipToRegion,
      ShipToCityName,
      ShipPostalCode,
      ShipGSTStateCode,
      ShipBno,
      ShipBdt,
      Port,
      ForCur,
      CntCode,
      TransId,
      TransName,
      TransDocNo,
      TransDocDt,
      VehNo,
      VehType,
      TransMode,
      Message,
      Status
}
