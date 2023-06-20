global class B2B2C_CartItem {
    @AuraEnabled
    global String cartId { get; set; }
    @AuraEnabled
    global String cartItemId { get; set; }
    @AuraEnabled
    global ConnectApi.CartItemProduct productDetails { get; set; }
    @AuraEnabled
    global String listPrice { get; set; }
    @AuraEnabled
    global String quantity { get; set; }
    @AuraEnabled
    global String salesPrice { get; set; }
    @AuraEnabled
    global String totalAmount { get; set; }
    @AuraEnabled
    global String totalListPrice { get; set; }
    @AuraEnabled
    global String totalPrice { get; set; }
    @AuraEnabled
    global String unitAdjustedPrice { get; set; }
    @AuraEnabled
    global ConnectApi.CartItemType type { get; set; } 
    @AuraEnabled
    global String productClass { get; set; } // Related, Deliverable Subscription, Simple
    @AuraEnabled
    global String parentProductId { get; set; }
    @AuraEnabled
    global List<String> relatedCartItemIds { get; set; }
    @AuraEnabled
    global B2B2C_SubscriptionOption selectedOption { get; set; }
    @AuraEnabled
    public List<B2B2C_SubscriptionOption> subscriptionOptions { get; set; }
    @AuraEnabled
    global String numberOfDeliveries { get; set; }
    @AuraEnabled
    global String feature { get; set; }
    @AuraEnabled
    global String shortDescription { get; set; }
    
}