global class B2B2C_ProductDetail {
	
    global class Request{
        @AuraEnabled
        global String effectiveAccountId { get; set; }
        @AuraEnabled
        global String productId { get; set; }
		/*@AuraEnabled
        global String quantity;        
        @AuraEnabled
        global List<String> relatedProductIds;*/
    }
    
    global class Response{
        @AuraEnabled
        global Map<String, ConnectApi.ProductAttributeSetInfo> attributeSetInfo { get; set; }
        @AuraEnabled
        global ConnectApi.ProductMedia defaultImage { get; set; }
        @AuraEnabled
        global Map<String, String> fields { get; set; }
        @AuraEnabled
        global String id { get; set; }
        @AuraEnabled
        global List<ConnectApi.ProductMediaGroup> mediaGroups { get; set; }
        @AuraEnabled
        global ConnectApi.ProductCategoryPath primaryProductCategoryPath { get; set; }
        @AuraEnabled
        global ConnectApi.ProductClass productClass { get; set; }
        @AuraEnabled
        global List<ConnectApi.ProductSellingModel> productSellingModels { get; set; }
        @AuraEnabled
        global ConnectApi.PurchaseQuantityRule purchaseQuantityRule { get; set; }
        @AuraEnabled
        global ConnectApi.ProductAttributeSet variationAttributeSet { get; set; }
        @AuraEnabled
        global ConnectApi.ProductVariationInfo variationInfo { get; set; }
        @AuraEnabled
        global String variationParentId { get; set; }
        @AuraEnabled
        global ConnectApi.ProductPrice price { get; set; }
        @AuraEnabled
        global List<ConnectApi.ProductOverview> relatedProducts { get; set; }
        @AuraEnabled
        global Boolean isSubscription { get; set; }
        @AuraEnabled
        global B2B2C_SubscriptionDetail subscriptionDetail { get; set; }
        @AuraEnabled
    	global String feature { get; set; }
        
        global Response(){}
        public Response(
            ConnectApi.ProductDetail productDetail, 
            ConnectApi.ProductPrice price, 
            List<ConnectApi.ProductOverview> relatedProducts, 
            Boolean isSubscription, 
            B2B2C_SubscriptionDetail subscriptionDetail
        ){
            this.attributeSetInfo = productDetail.attributeSetInfo;
            this.defaultImage = productDetail.defaultImage;
            this.fields = productDetail.fields;
            this.id = productDetail.id;
            this.mediaGroups = productDetail.mediaGroups;
            this.primaryProductCategoryPath = productDetail.primaryProductCategoryPath;
            this.productClass = productDetail.productClass;
            this.productSellingModels = productDetail.productSellingModels;
            this.purchaseQuantityRule = productDetail.purchaseQuantityRule;
            this.variationAttributeSet = productDetail.variationAttributeSet;
            this.variationInfo = productDetail.variationInfo;
            this.variationParentId = productDetail.variationParentId;
            this.price = price;
            this.relatedProducts = relatedProducts;
            this.isSubscription = isSubscription;
            this.subscriptionDetail = subscriptionDetail;
        }
    }
    
}