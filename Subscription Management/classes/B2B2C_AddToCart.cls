global class B2B2C_AddToCart {
	global class Request{
        @AuraEnabled
        global String effectiveAccountId { get; set; }
        @AuraEnabled
        global String productId { get; set; }
        @AuraEnabled
        global String quantity { get; set; }       
        @AuraEnabled
        global List<String> relatedProductIds { get; set; }
        @AuraEnabled
        global Boolean hasRelatedProducts { get; set; }
        @AuraEnabled
        global Boolean isSubscription { get; set; }
        @AuraEnabled
    	public String subscriptionType { get; set; }
        @AuraEnabled
        public Boolean isOneTimePurchase { get; set; }
        @AuraEnabled
        public String numberOfDeliveries { get; set; }
        @AuraEnabled
        public B2B2C_SubscriptionOption selectedSubscriptionOption { get; set; }
    }
    
    global class Response{
        @AuraEnabled
        global Boolean success { get; set; }
        @AuraEnabled
        global String cartId { get; set; }
    }
}