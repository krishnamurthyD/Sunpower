global class B2B2C_Cart {
	global class Request{
        @AuraEnabled
        global String effectiveAccountId { get; set; }
    }
    
    global class Response{
        @AuraEnabled
        global List<B2B2C_CartItem> cartItems { get; set; }
        @AuraEnabled
        global ConnectApi.CartSummary cartSummary { get; set; }
    }
}