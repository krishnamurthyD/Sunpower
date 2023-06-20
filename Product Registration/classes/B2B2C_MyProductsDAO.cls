global inherited sharing class B2B2C_MyProductsDAO {
    global static List<B2B2C_Registered_Product__c> getMyRegisteredProducts(String contactId) {
        return [SELECT Id, Invoice_Number__c, Model_Number__c, Product__c, Product_Code__c, 
                Purchase_Date__c, Purchase_Price__c, Registered_Date__c, Serial_Number__c,
                Product__r.Name, Product__r.b2b2c_Allow_Warranty_Extension_After_Exp__c,
                Product__r.b2b2c_Eligible_for_Warranty__c, Product__r.b2b2c_Product_Warranty__c,
                Product__r.b2b2c_RelatedProductCodes__c  
                FROM B2B2C_Registered_Product__c 
                WHERE Contact__c=:contactId 
                WITH SECURITY_ENFORCED 
                ORDER BY Purchase_Date__c DESC];
    }

    global static List<Product2> getProducts(Set<String> productIdSet) {
        return [SELECT Id, Name, (SELECT Id FROM Products__r) FROM Product2 WHERE Id IN :productIdSet WITH SECURITY_ENFORCED];
    }
}