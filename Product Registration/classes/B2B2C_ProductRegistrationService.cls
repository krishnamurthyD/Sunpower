global class B2B2C_ProductRegistrationService implements IB2B2C_ProductRegistrationService{
    
    global static boolean validateSerialNumber(String serialNumber){
        if(serialNumber.length()>14){
            return true;
        }
        return false;
    }

    global static boolean validateProductCode(String productCode){
        Product2 prod = B2B2C_ProductRegistrationDAO.getProductInfo(productCode);
        if(prod!=null){
            return true;
        }
        return false;
    }

    global static boolean validatePurchaseDate(Date purchaseDate, Integer pastDateMargin){
        Date today = System.today();
        if(purchaseDate<=today && purchaseDate>today.addDays(-pastDateMargin)){
            return true;
        }
        return false;
    }

    global static Object registerProduct(Object request){
        B2B2C_ProductRegistration_Response response = new B2B2C_ProductRegistration_Response();
        B2B2C_ProductRegistration_Request productData = (B2B2C_ProductRegistration_Request)request;
        response.isSuccess = false;
        response.message = 'Please verify the product data';

        System.debug('[RB] - B2B2C_ProductRegistration.registerProduct :: productData => ' + productData);
        
        if(!validateSerialNumber(productData.serialNumber)) {
            return response;
        }
        if(!validateProductCode(productData.productCode)) {
            return response;
        }
        if(!validatePurchaseDate(productData.purchaseDate, productData.pastDateMargin)) {
            return response;
        }

        Product2 prod = B2B2C_ProductRegistrationDAO.getProductInfo(productData.productCode);
        User loggedInUser = B2B2C_ProductRegistrationDAO.getLoggedInUserInfo(UserInfo.getUserId());

        B2B2C_Registered_Product__c regProd = new B2B2C_Registered_Product__c();
        regProd.Contact__c = loggedInUser.ContactId;
        regProd.Product__c = prod.Id;
        regProd.Product_Code__c = productData.productCode;
        regProd.Serial_Number__c = productData.serialNumber;
        regProd.Purchase_Date__c = productData.purchaseDate;
        regProd.Purchase_Price__c = productData.purchasedPrice;
        regProd.Registered_Date__c = System.today();

        try {
            B2B2C_ProductRegistrationDAO.insertRecords(new List<B2B2C_Registered_Product__c>{regProd});
            response.isSuccess = true;
            response.message = 'Product Registered Successfully';
        } catch(Exception e) {
            response.isSuccess = false;
            response.message = 'Something went wrong';
            System.debug('[RB] - B2B2C_ProductRegistrationService.registerProduct :: Error Message => ' + e.getMessage());
        } 

        return response;
    }
}