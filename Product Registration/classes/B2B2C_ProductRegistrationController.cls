public without sharing class B2B2C_ProductRegistrationController {

    @AuraEnabled
    public static boolean validateSerialNumber(String serialNumber, String serviceClassName){
        Type serviceType = Type.forName(serviceClassName);
        IB2B2C_ProductRegistrationService serviceClass = (IB2B2C_ProductRegistrationService)serviceType.newInstance();
        return serviceClass.validateSerialNumber(serialNumber);
    }

    @AuraEnabled
    public static boolean validateProductCode(String productCode, String serviceClassName){
        Type serviceType = Type.forName(serviceClassName);
        IB2B2C_ProductRegistrationService serviceClass = (IB2B2C_ProductRegistrationService)serviceType.newInstance();
        return serviceClass.validateProductCode(productCode);
    }

    @AuraEnabled
    public static boolean validatePurchaseDate(Date purchaseDate, Integer pastDateMargin, String serviceClassName){
        Type serviceType = Type.forName(serviceClassName);
        IB2B2C_ProductRegistrationService serviceClass = (IB2B2C_ProductRegistrationService)serviceType.newInstance();
        return serviceClass.validatePurchaseDate(purchaseDate, pastDateMargin);
    }

    @AuraEnabled
    public static B2B2C_ProductRegistration_Response registerProduct(B2B2C_ProductRegistration_Request productData, String serviceClassName){
        Type serviceType = Type.forName(serviceClassName);
        IB2B2C_ProductRegistrationService serviceClass = (IB2B2C_ProductRegistrationService)serviceType.newInstance();
        return (B2B2C_ProductRegistration_Response)serviceClass.registerProduct(productData);
    }
}