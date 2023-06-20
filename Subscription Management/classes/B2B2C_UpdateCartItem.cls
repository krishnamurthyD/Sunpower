global class B2B2C_UpdateCartItem {
	global class Request{
        @AuraEnabled
        global String cartItemId { get; set; }
        @AuraEnabled
        global String effectiveAccountId { get; set; }
        @AuraEnabled
        global String quantity { get; set; }
        @AuraEnabled
    	global List<String> relatedCartItemIds { get; set; }
        @AuraEnabled
    	global String numberOfDeliveries { get; set; }
        @AuraEnabled
    	global String productClass { get; set; }
        @AuraEnabled
    	global B2B2C_SubscriptionOption selectedOption { get; set; }
    }
}