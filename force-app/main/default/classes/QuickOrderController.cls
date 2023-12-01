public with sharing class QuickOrderController {
    
    @AuraEnabled(cacheable=true)
    public static List<Product2> searchProducts(String searchQuery) {
        String query = 'SELECT Id, Name, ProductCode, Price__c FROM Product2 WHERE Name LIKE \'%' + searchQuery + '%\'';
        return Database.query(query);
    }
    
    @AuraEnabled
    public static void addToCart(String productId, Integer quantity) {
        List<Id> pricebookIds = new List<Id>();
        for (Pricebook2 pricebook : [SELECT Id FROM Pricebook2 WHERE IsStandard = true]) {
            pricebookIds.add(pricebook.Id);
        }
        
        List<PricebookEntry> pricebookEntries = [SELECT Id, Pricebook2Id, Product2Id, UnitPrice FROM PricebookEntry WHERE Pricebook2Id IN :pricebookIds AND Product2Id = :productId LIMIT 1];
        
        if (pricebookEntries.size() == 1) {
            Id pricebookEntryId = pricebookEntries[0].Id;
            
            PricebookEntry newPricebookEntry = new PricebookEntry(
                Id = pricebookEntryId,
                UnitPrice = pricebookEntries[0].UnitPrice,
                IsActive = true,
                UseStandardPrice = false,
                Pricebook2Id = pricebookEntries[0].Pricebook2Id,
                Product2Id = productId,
                Quantity2__c = quantity
            );
            
            List<PricebookEntry> newPricebookEntries = new List<PricebookEntry>();
           // Add PricebookEntry records to the newPricebookEntries list
             List<Database.SaveResult> results = new List<Database.SaveResult>();
                   for (PricebookEntry pbe : newPricebookEntries) {
                results.add(Database.insert(pbe, false));
                 }
            
            if (results[0].isSuccess() == false) {
                throw new AuraHandledException('An error occurred while adding the item to the cart.');
            }
        }
        else {
            throw new AuraHandledException('An error occurred while adding the item to the cart.');
        }
    }
    
}