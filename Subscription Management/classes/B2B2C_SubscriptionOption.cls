public class B2B2C_SubscriptionOption {
    @AuraEnabled
	public String intervalTermUnit { get; set; } // Day, Month, Year
    @AuraEnabled
    public String intervalTerm { get; set; } // Number 
    @AuraEnabled
    public String listPrice { get; set; }
    @AuraEnabled
    public String unitPrice { get; set; }
    @AuraEnabled
    public String intervalLabel { get; set; }
    @AuraEnabled
    public String currencyCode { get; set; }
    @AuraEnabled
    public String id { get; set; }
}