@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'BILLING HEADER'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_BILLING_HEADER
  as select distinct from I_BillingDocumentItem         as _Item
    inner join            I_BillingDocument             as _Bill          on _Bill.BillingDocument = _Item.BillingDocument
    inner join            I_Plant                       as _Plant         on _Plant.Plant = _Item.Plant
    inner join            I_IN_PlantBusinessPlaceDetail as _Seller        on  _Seller.Plant         = _Item.Plant
                                                                          and _Seller.BusinessPlace = _Plant.BusinessPlace
    inner join            I_BusinessPlace               as _Bupla         on _Bupla.BusinessPlace = _Plant.BusinessPlace
    inner join            I_OrganizationAddress         as _Org           on _Org.AddressID = _Plant.AddressID
    inner join            I_BillingDocumentPartner      as _PartnerSeller on  _PartnerSeller.BillingDocument = _Bill.BillingDocument
                                                                          and _PartnerSeller.PartnerFunction = 'AG'
    inner join            I_Customer                    as _Buyer         on _Buyer.Customer = _PartnerSeller.Customer

    inner join            I_BillingDocumentPartner      as _PartnerShip   on  _PartnerShip.BillingDocument = _Bill.BillingDocument
                                                                          and _PartnerShip.PartnerFunction = 'WE'
    inner join            I_Customer                    as _Ship          on _Ship.Customer = _PartnerShip.Customer

    left outer join       zdb_einv_resp                 as _Response      on _Response.docno = _Item.BillingDocument
  //composition of target_data_source_name as _association_name
{
  key _Item.BillingDocument                                 as BillingDoc,
      _Bill.BillingDocumentDate                             as Dt,
      case
      when _Bill.BillingDocumentType = 'F2' then 'INV'
      when _Bill.BillingDocumentType = 'G2' then 'CRN'
      when _Bill.BillingDocumentType = 'L2' then 'DBN'
      end                                                   as BillingType,
      _Bill.DistributionChannel,
      case
      when _Bill.DistributionChannel = '20' then 'URP'
      else
      _Buyer.TaxNumber3
      end                                                   as BuyerGSTIN,

      _Buyer.CustomerName                                   as BuyerName,
      _Buyer.StreetName                                     as BuyerStreet,
      _Buyer.Region                                         as BuyerRegion,
      _Buyer.CityName                                       as BuyerCityName,
      case
      when _Bill.DistributionChannel = '20' then '999999'
      else
      _Buyer.PostalCode
      end                                                   as BuyerPostalCode,

      case
      when _Bill.DistributionChannel = '20' then '96'
      else
      substring( _Buyer.TaxNumber3, 1, 2 )
      end                                                   as BuyerGSTStateCode,

      _Seller.PlantName                                     as SellerName,
      //   _Org.AddresseeFullName,
      _Bupla.IN_GSTIdentificationNumber                     as SellerGst,
      _Org.StreetName                                       as SellerStreetName,
      _Org.HouseNumber                                      as SellerHouseNumber,
      _Org.Street                                           as SellerStreet,
      _Org.CityName                                         as SellerCityName,
      _Org.PostalCode                                       as SellerPostalCode,
      substring( _Bupla.IN_GSTIdentificationNumber , 1, 2 ) as SellerStateCode,
      case
      when _Bill.DistributionChannel = '20' then ''
      else
      _Ship.TaxNumber3
      end                                                   as ShipGSTIN,

      _Ship.CustomerName                                    as ShipName,
      _Ship.StreetName                                      as ShipStreet,
      _Ship.Region                                          as ShipToRegion,
      _Ship.CityName                                        as ShipToCityName,
      _Ship.PostalCode                                      as ShipPostalCode,
      substring( _Ship.TaxNumber3, 1, 2 )                   as ShipGSTStateCode,
      _Bill.YY1_PackingListNo_BDH                           as ShipBno,
      _Bill.YY1_PackingListDate_BDH                         as ShipBdt,
      _Bill.YY1_CityPortOfLoading_BDH                       as Port,
      _Bill.TransactionCurrency                             as ForCur,
      _Bill.YY1_Countryoffinaldes_BDH                       as CntCode,
      _Bill.YY1_TransporterID_BDH                           as TransId,
      _Bill.YY1_TransporterName_BDH                         as TransName,
      _Bill.YY1_LRNo_BDH                                    as TransDocNo,
      _Bill.YY1_LRDate_BDH                                  as TransDocDt,
      _Bill.YY1_EWayVehicleNo_BDH                           as VehNo,
      _Bill.YY1_EWayVehicleType_BDH                         as VehType,
      _Bill.YY1_Mode_BDH                                    as TransMode,
      _Response.message                                     as Message,
      _Response.status                                      as Status

      //  _association_name // Make association public
}
