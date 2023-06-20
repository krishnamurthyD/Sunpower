global inherited sharing class B2B2C_MySubscriptionsDAO {
    
    global static List<B2B2C_Subscription__c> getMysubscriptionProducts() {
        return [SELECT Id, B2B2C_Interval__c, B2B2C_Interval_Term_Unit__c, B2B2C_Status__c,
                B2B2C_Number_of_deliveries__c, B2B2C_Quantity__c, B2B2C_Start_Date__c, 
                B2B2C_Next_Delivery_Date__c, B2B2C_Cancellation_Reason__c, 
                B2B2C_Order_Product__c, B2B2C_Order_Product__r.Description, 
                B2B2C_Order_Product__r.Product2Id, B2B2C_Order_Product__r.Product2.Name, 
                B2B2C_Order_Product__r.Product2.StockKeepingUnit,
                B2B2C_Order_Product__r.Product2.ProductCode, B2B2C_Order_Product__r.Quantity, 
                B2B2C_Order_Product__r.ListPrice, B2B2C_Order_Product__r.UnitPrice 
                FROM B2B2C_Subscription__c 
                WHERE OwnerId = :userinfo.getuserid()
                WITH SECURITY_ENFORCED 
                ORDER BY B2B2C_Start_Date__c DESC];
    }

    global static List<ProductAttribute> getProductAttributes(String subscriptionProductId) {
        List<ProductAttribute> prodAttributesList = new List<ProductAttribute>();
        prodAttributesList = [SELECT VariantParentId FROM ProductAttribute Where ProductId = : subscriptionProductId];
        
        prodAttributesList = [SELECT VariantParentId, ProductId, Product.B2B2C_Subscription_Metadata__c, Delivery_Interval__c FROM ProductAttribute Where VariantParentId = :prodAttributesList[0].VariantParentId];
        return prodAttributesList;
    }

    global static void updateRecords(List<SObject> newRecords) {
        update newRecords;
    }
}