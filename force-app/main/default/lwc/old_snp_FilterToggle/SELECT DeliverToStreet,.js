SELECT DeliverToStreet,
DeliverToCity,
DeliverToState, 
DeliverToName, 
DeliverToLastName,
DeliverToFirstName, 
ShippingInstructions,
DesiredDeliveryDate,
DeliveryMethodId,
CartId, 
SystemModstamp,
LastModifiedById, 
LastModifiedDate, 
CreatedById, 
CreatedDate, 
CurrencyIsoCode,
Name,
IsDeleted,
Id,
DeliverToPostalCode, 
DeliverToCountry,
DeliverToStateCode,
DeliverToCountryCode, 
DeliverToLatitude, 
DeliverToLongitude, 
DeliverToGeocodeAccuracy, 
DeliverToAddress, 
IsDefault,
TotalProductAmount, 
TotalChargeAmount, 
TotalAmount, 
TotalProductTaxAmount, 
TotalChargeTaxAmount, 
TotalTaxAmount,
GrandTotalAmount, 
TotalAdjustmentAmount, TotalAdjustmentTaxAmount, SelectedDeliveryMethodId, ShipToPhoneNumber, 
CompanyName FROM CartDeliveryGroup





  'name' => cpa.AddressFirstName+''+cpa.AddressLastName ,    => DeliverToLastName+DeliverToLastName
  'company' => cpa.CompanyName ,                             => CompanyName
  'street1' => cpa.Street,                                   => DeliverToStreet
  'street2' => '',                                           => not required
  'city' => cpa.City,                                        => DeliverToCity
  'state' => '',                                             => not required
  'zip' => cpa.PostalCode,                                   => DeliverToStateCode
  'country' => cpa.CountryCode ,                             => DeliverToCountryCode
  'phone' => cpa.PhoneNumber ,                               => ShipToPhoneNumber
  'email' => acc.PersonEmail