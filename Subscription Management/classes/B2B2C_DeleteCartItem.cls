global class B2B2C_DeleteCartItem {
	global class Request{
        @AuraEnabled
        global String cartItemId { get; set; }
        @AuraEnabled
        global String effectiveAccountId { get; set; }
        @AuraEnabled
    	global List<String> relatedCartItemIds { get; set; }
    }
    
}