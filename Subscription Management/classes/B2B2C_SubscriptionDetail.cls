public class B2B2C_SubscriptionDetail {
	@AuraEnabled
    public Boolean isOneTimePurchaseAllowed { get; set; }
    @AuraEnabled
    public String subscribeDescription { get; set; }
    @AuraEnabled
    public String oneTimeDescription { get; set; }
    @AuraEnabled
    public String subscriptionType { get; set; }
    @AuraEnabled
    public List<B2B2C_SubscriptionOption> subscriptionOptions { get; set; }
    @AuraEnabled
    public B2B2C_SubscriptionOption oneTimePurchaseOption { get; set; }
}