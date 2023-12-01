public class multiCurrencyController {
    @AuraEnabled
    public static List<PricebookEntry> getProductPrices(String productIdFromWebsite, string CurrencyIsoCodeFromWebsite) {
        Id productId = productIdFromWebsite;
        string CurrencyIsoCode=CurrencyIsoCodeFromWebsite;

        // Query the PricebookEntry records for the given product ID
        List<PricebookEntry> priceBookEntries = [SELECT Pricebook2Id, UnitPrice, Pricebook2.CurrencyIsoCode
                                                 FROM PricebookEntry
                                                 WHERE Product2Id = :productId and Pricebook2.CurrencyIsoCode=:CurrencyIsoCode ];
		return priceBookEntries;
    }
}