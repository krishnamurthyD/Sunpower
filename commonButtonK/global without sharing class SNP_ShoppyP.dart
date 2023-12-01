global without sharing class SNP_ShoppyPro_Shipping_Integration implements sfdc_checkout.CartShippingCharges {
    global sfdc_checkout.IntegrationStatus startCartProcessAsync(sfdc_checkout.IntegrationInfo jobInfo, Id cartId) {
        sfdc_checkout.IntegrationStatus integStatus = new sfdc_checkout.IntegrationStatus();
        try {
            // We need to get the ID of the cart delivery group in order to create the order delivery groups.
            // WITH SECURITY_ENFORCED
            Id cartDeliveryGroupId = [SELECT Id FROM CartDeliveryGroup WHERE CartId = :cartId][0].Id;

            // Used to increase the cost by a multiple of the number of items in the cart (useful for testing but should not be done in the final code)
            // WITH SECURITY_ENFORCED
            Integer numberOfUniqueItems = [SELECT count() FROM cartItem WHERE CartId = :cartId];

            // Get shipping options from the external service.
            List<ShippingOptionsAndRatesFromExternalService> shippingOptions = getShippingOptionsAndRatesFromExternalService(cartId);

            // On re-entry of the checkout flow delete all previous CartDeliveryGroupMethods for the given cartDeliveryGroupId
            // WITH SECURITY_ENFORCED
            delete [SELECT Id FROM CartDeliveryGroupMethod WHERE CartDeliveryGroupId = :cartDeliveryGroupId];

            // Create orderDeliveryMethods given your shipping options or fetch existing ones. 2 should be returned.
            List<Id> orderDeliveryMethodIds = getOrderDeliveryMethods(shippingOptions);

            // Create a CartDeliveryGroupMethod record for every shipping option returned from the external service
            Integer i = 0;
            for (Id orderDeliveryMethodId : orderDeliveryMethodIds) {
                populateCartDeliveryGroupMethodWithShippingOptions(shippingOptions[i], cartDeliveryGroupId, orderDeliveryMethodId, cartId);
                i += 1;
            }

            // If everything works well, the charge is added to the cart, and our integration has been successfully completed.
            integStatus.status = sfdc_checkout.IntegrationStatus.Status.SUCCESS;
        } catch (DmlException de) {
            Integer numErrors = de.getNumDml();
            String errorMessage = 'There were ' + numErrors + ' errors when trying to insert the charge in the CartItem: ';
            for (Integer errorIdx = 0; errorIdx < numErrors; errorIdx++) {
                errorMessage += 'Field Names = ' + de.getDmlFieldNames(errorIdx);
                errorMessage += 'Message = ' + de.getDmlMessage(errorIdx);
                errorMessage += ' , ';
            }

            return integrationStatusFailedWithCartValidationOutputError(integStatus, errorMessage, jobInfo, cartId);
        } catch (Exception e) {
            return integrationStatusFailedWithCartValidationOutputError(
                integStatus,
                'An exception of type ' + e.getTypeName() + ' has occurred: ' + e.getMessage(),
                jobInfo,
                cartId
            );
        }
        return integStatus;
    }

    private List<ShippingOptionsAndRatesFromExternalService> getShippingOptionsAndRatesFromExternalService(id cartId) {
        final Integer SuccessfulHttpRequest = 200;
        
        
    //    String jsonPayload = '{"Method": "GetRates", "Params": { "to_address": { "name": "John Doe", "company": "ShippyPro", "street1": "Calleva Park Orion House", "street2": "", "city": "Aldermaston", "state": "", "zip": "RG7 8SN", "country": "GB", "phone": "5551231234", "email": "johndoe@gmail.com" }, "from_address": { "name": "Diane Baker", "company": "Sunpower Group Holdings Ltd", "street1": "Calleva Park Orion House", "street2": "", "city": "Aldermaston", "state": "", "zip": "RG7 8SN", "country": "GB", "phone": "1189811001", "email": "diane.baker@sunpower-uk.com" }, "parcels": [ { "length": 5, "width": 5, "height": 5, "weight": 10 } ], "Insurance": 0, "InsuranceCurrency": "EUR", "CashOnDelivery": 0, "CashOnDeliveryCurrency": "EUR", "ContentDescription": "Shoes", "TotalValue": "50.25 EUR", "ShippingService": "Standard" }}';
        // WITH SECURITY_ENFORCED
        CartDeliveryGroup cpa = [SELECT Id, CompanyName, DeliverToFirstName, DeliverToLastName, DeliverToCity, DeliverToState, DeliverToPostalCode, DeliverToStateCode, DeliverToCountryCode, DeliverToCountry, DeliverToStreet, CurrencyIsoCode, CartId, ShippingInstructions, DeliverToAddress, ShipToPhoneNumber FROM CartDeliveryGroup where CartId =: cartId];
         
        
        Map<String, Object> payload = new Map<String, Object>{
    'Method' => 'GetRates',
    'Params' => new Map<String, Object>{
        'to_address' => new Map<String, Object>{
            'name' => cpa.DeliverToFirstName+''+cpa.DeliverToLastName,
            'company' => cpa.CompanyName,
            'street1' => cpa.DeliverToStreet,
            'street2' => '',
            'city' => cpa.DeliverToCity,
            'state' => '',
            'zip' => cpa.DeliverToPostalCode,
            'country' => cpa.DeliverToCountryCode,
            'phone' => cpa.ShipToPhoneNumber,
            'email' => 'krishnamurthydonta@gmail.com' // Fix the typo here
        },
        'from_address' => new Map<String, Object>{
            'name' => 'Diane Baker',
            'company' => 'Sunpower Group Holdings Ltd',
            'street1' => 'Calleva Park Orion House',
            'street2' => '',
            'city' => 'Aldermaston',
            'state' => '',
            'zip' => 'RG7 8SN',
            'country' => 'GB',
            'phone' => '1189811001',
            'email' => 'diane.baker@sunpower-uk.com'
        },
        'parcels' => new List<Map<String, Object>>{
            new Map<String, Object>{
                'length' => 10,
                'width' => 12,
                'height' => 10,
                'weight' => 20
            },
            new Map<String, Object>{
                'length' => 5,
                'width' => 10,
                'height' => 5,
                'weight' => 12
            },
            new Map<String, Object>{
                'length' => 5,
                'width' => 23,
                'height' => 15,
                'weight' => 10
            },
            new Map<String, Object>{
                'length' => 15,
                'width' => 5,
                'height' => 95,
                'weight' => 100
            },
                new Map<String, Object>{
                'length' => 5,
                'width' => 5,
                'height' => 52,
                'weight' => 13
            }
        }
    }
};

     /*   Map<String, Object> payload = new Map<String, Object>{
    	'Method' => 'GetRates',
    	'Params' => new Map<String, Object>{
        'to_address' => new Map<String, Object>{
            'name' => cpa.DeliverToFirstName+''+cpa.DeliverToLastName ,
            'company' => cpa.CompanyName ,
            'street1' => cpa.DeliverToStreet,
            'street2' => '',
            'city' => cpa.DeliverToCity,
            'state' => '',
            'zip' => cpa.DeliverToPostalCode,
            'country' => cpa.DeliverToCountryCode ,
            'phone' => cpa.ShipToPhoneNumber ,
            'email' => 'krishnamurthydonta@gamil.com'
        },
        'from_address' => new Map<String, Object>{
            'name' => 'Diane Baker',
            'company' => 'Sunpower Group Holdings Ltd',
            'street1' => 'Calleva Park Orion House',
            'street2' => '',
            'city' => 'Aldermaston',
            'state' => '',
            'zip' => 'RG7 8SN',
            'country' => 'GB',
            'phone' => '1189811001',
            'email' => 'diane.baker@sunpower-uk.com'
        },
        'parcels' => new List<Map<String, Object>>{
            new Map<String, Object>{
                //dimension_unit :- Parcel unit of measurement for lenght: "CM" (default),  (OR) "IN"	2 char
                'length' => 10,
                'width' => 12,
                'height' => 10,
                'weight' => 20
                     },
                 new Map<String, Object>{
                'length' => 5,
                'width' => 5,
                'height' => 5,
                'weight' => 10
                 },
                new Map<String, Object>{
                'length' => 5,
                'width' => 5,
                'height' => 5,
                'weight' => 10
                 },
                new Map<String, Object>{
                'length' => 5,
                'width' => 5,
                'height' => 5,
                'weight' => 10
                }
                 //Insurance is not mandatery we can avoide Insurance 
             }
            };*/
                
        Http HttpProducts = new Http();
        HttpRequest requestP = new HttpRequest();
        String jsonPayload = JSON.serialize(payload);
        requestP.setBody(jsonPayload);
        requestP.setEndpoint('https://www.shippypro.com/api/v1');
        requestP.setMethod('GET');
        requestP.setHeader('Content-Type', 'application/json');
        requestP.setHeader('Authorization', 'Basic NDNiYmY2NmU4OGQyY2YwYjIyZDdhOGM1OWI0ZDQ2NTg6');
        HttpResponse responseP = HttpProducts.send(requestP);
        String jsonResponse = responseP.getBody();

        System.debug('response ' + responseP);
        System.debug('response body ' + responseP.getBody());

        List<ShippingOptionsAndRatesFromExternalService> shippingOptions = new List<ShippingOptionsAndRatesFromExternalService>();

        if (!String.isBlank(jsonResponse)) {
            Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(jsonResponse);
            List<Object> ratesList = (List<Object>) responseMap.get('Rates');

            for (Object rateObj : ratesList) {
                Map<String, Object> rateMap = (Map<String, Object>) rateObj;

                String carrier = (String) rateMap.get('service');
                String service = (String) rateMap.get('service');
                Decimal rate = (Decimal) rateMap.get('rate');
                Decimal otherCost = 0; // You can modify this if you have other cost information
                String serviceName = (String) rateMap.get('carrier');

                ShippingOptionsAndRatesFromExternalService shippingOption = new ShippingOptionsAndRatesFromExternalService(
                    carrier,
                    service,
                    rate,
                    otherCost,
                    serviceName
                );

                shippingOptions.add(shippingOption);
            }
            return shippingOptions;
        } else {
            throw new CalloutException('There was a problem with the request. Error: ' + responseP.getStatusCode());
        }
    }

    // Structure to store the shipping options retrieved from external service.
    Class ShippingOptionsAndRatesFromExternalService {
        private String name;
        private String provider;
        private Decimal rate;
        private Decimal otherCost;
        private String serviceName;

        public ShippingOptionsAndRatesFromExternalService(String someName, String someProvider, Decimal someRate, Decimal someOtherCost, String someServiceName) {
            name = someName;
            provider = someProvider;
            rate = someRate;
            otherCost = someOtherCost;
            serviceName = someServiceName;
        }

        public String getProvider() {
            return provider;
        }

        public Decimal getRate() {
            return rate;
        }

        public Decimal getOtherCost() {
            return otherCost;
        }

        public String getServiceName() {
            return serviceName;
        }

        public String getName() {
            return name;
        }
    }

  // Create a CartDeliveryGroupMethod record for every shipping option returned from the external service
    private void populateCartDeliveryGroupMethodWithShippingOptions(ShippingOptionsAndRatesFromExternalService shippingOption,
                                                                  Id cartDeliveryGroupId,
                                                                  Id deliveryMethodId,
                                                                  Id webCartId){
        // When inserting a new CartDeliveryGroupMethod, the following fields have to be populated:
        // CartDeliveryGroupId: Id of the delivery group of this shipping option
        // DeliveryMethodId: Id of the delivery method for this shipping option
        // ExternalProvider: Unique identifier of shipping provider
        // Name: Name of the CartDeliveryGroupMethod record
        // ShippingFee: The cost of shipping for the delivery group
        // WebCartId: Id if the cart that the delivery group belongs to
        CartDeliveryGroupMethod cartDeliveryGroupMethod = new CartDeliveryGroupMethod(
            CartDeliveryGroupId = cartDeliveryGroupId,
            DeliveryMethodId = deliveryMethodId,
            ExternalProvider = shippingOption.getProvider(),
            Name = shippingOption.getName(),
            ShippingFee = shippingOption.getRate(),
            WebCartId = webCartId
        );
        insert(cartDeliveryGroupMethod);
    }

    private sfdc_checkout.IntegrationStatus integrationStatusFailedWithCartValidationOutputError(
        sfdc_checkout.IntegrationStatus integrationStatus, String errorMessage, sfdc_checkout.IntegrationInfo jobInfo, Id cartId) {
            integrationStatus.status = sfdc_checkout.IntegrationStatus.Status.FAILED;
            // In order for the error to be propagated to the user, we need to add a new CartValidationOutput record.
            // The following fields must be populated:
            // BackgroundOperationId: Foreign Key to the BackgroundOperation
            // CartId: Foreign key to the WebCart that this validation line is for
            // Level (required): One of the following - Info, Error, or Warning
            // Message (optional): Message displayed to the user
            // Name (required): The name of this CartValidationOutput record. For example CartId:BackgroundOperationId
            // RelatedEntityId (required): Foreign key to WebCart, CartItem, CartDeliveryGroup
            // Type (required): One of the following - SystemError, Inventory, Taxes, Pricing, Shipping, Entitlement, Other
            CartValidationOutput cartValidationError = new CartValidationOutput(
                BackgroundOperationId = jobInfo.jobId,
                CartId = cartId,
                Level = 'Error',
                Message = errorMessage.left(255),
                Name = (String)cartId + ':' + jobInfo.jobId,
                RelatedEntityId = cartId,
                Type = 'Shipping'
            );
            insert(cartValidationError);
            return integrationStatus;
    }

    private Id getShippingChargeProduct2Id(Id orderDeliveryMethodId) {
        // The Order Delivery Method should have a Product2 associated with it, because we added that in getDefaultOrderDeliveryMethod if it didn't exist.
        // WITH SECURITY_ENFORCED
        List<OrderDeliveryMethod> orderDeliveryMethods = [SELECT ProductId FROM OrderDeliveryMethod WHERE Id = :orderDeliveryMethodId ];
        return orderDeliveryMethods[0].ProductId;
    }

    private List<Id> getOrderDeliveryMethods(List<ShippingOptionsAndRatesFromExternalService> shippingOptions) {
        String defaultDeliveryMethodName = 'Order Delivery Method';
        Id product2IdForThisDeliveryMethod = getDefaultShippingChargeProduct2Id();

        // Check to see if a default OrderDeliveryMethod already exists.
        // If it doesn't exist, create one.
        List<Id> orderDeliveryMethodIds = new List<Id>();
        List<OrderDeliveryMethod> orderDeliveryMethods = new List<OrderDeliveryMethod>();
        Integer i = 1;
        for (ShippingOptionsAndRatesFromExternalService shippingOption: shippingOptions) {
            String shippingOptionNumber = String.valueOf(i);
            String name = defaultDeliveryMethodName + shippingOptionNumber;
           // WITH SECURITY_ENFORCED
            List<OrderDeliveryMethod> odms = [SELECT Id, ProductId, Carrier, ClassOfService FROM OrderDeliveryMethod WHERE Name = :name ];
            // This is the case in which an Order Delivery method does not exist.
            if (odms.isEmpty()) {
                OrderDeliveryMethod defaultOrderDeliveryMethod = new OrderDeliveryMethod(
                    Name = name,
                    Carrier = shippingOption.serviceName,
                    isActive = true,
                    ProductId = product2IdForThisDeliveryMethod,
                    ClassOfService = shippingOption.provider
                );
                insert(defaultOrderDeliveryMethod);
                orderDeliveryMethodIds.add(defaultOrderDeliveryMethod.Id);
            }
            else {
                // This is the case in which an Order Delivery method exists.
                // If the OrderDeliveryMethod doesn't have a Product2 associated with it, assign one
                // We can always pick the 0th orderDeliveryMethod since we queried based off the name.
                OrderDeliveryMethod existingodm = odms[0];
                // This is for reference implementation purposes only.
                // This is the if statement that checks to make sure that there is a product carrier and class of service
                // associated to the order delivery method.
                if (existingodm.ProductId == null || existingodm.Carrier == null || existingodm.ClassOfService == null) {
                    existingodm.ProductId = product2IdForThisDeliveryMethod;
                    existingodm.Carrier = shippingOption.serviceName;
                    existingodm.ClassOfService = shippingOption.provider;
                    update(existingodm);
                }
                orderDeliveryMethodIds.add(existingodm.Id);
            }
            i+=1;
        }
        return orderDeliveryMethodIds;
    }

    private Id getDefaultShippingChargeProduct2Id() {
        // In this example we will name the product representing shipping charges 'Shipping Charge for this delivery method'.
        // Check to see if a Product2 with that name already exists.
        // If it doesn't exist, create one.
        String shippingChargeProduct2Name = 'Shipping Charge for this delivery method';
        //WITH SECURITY_ENFORCED
        List<Product2> shippingChargeProducts = [SELECT Id FROM Product2 WHERE Name = :shippingChargeProduct2Name ];
        if (shippingChargeProducts.isEmpty()) {
            Product2 shippingChargeProduct = new Product2(
                isActive = true,
                Name = shippingChargeProduct2Name
            );
            insert(shippingChargeProduct);
            return shippingChargeProduct.Id;
        }
        else {
            return shippingChargeProducts[0].Id;
        }
    }
   

}