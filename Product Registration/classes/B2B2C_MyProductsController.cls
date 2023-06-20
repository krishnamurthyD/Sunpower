public without sharing class B2B2C_MyProductsController {
    
    @AuraEnabled
    public static B2B2C_MyProductsResponse getMyRegisteredProducts(String serviceClassName){
        User loggedInUser = [SELECT ContactId FROM User WHERE Id= :userinfo.getuserid()];
        Type serviceType = Type.forName(serviceClassName);
        IB2B2C_MyProductsService serviceClass = (IB2B2C_MyProductsService)serviceType.newInstance();
        return (B2B2C_MyProductsResponse)serviceClass.getMyRegisteredProducts(loggedInUser.ContactId);
    }
}