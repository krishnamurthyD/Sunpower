public without sharing class B2B2C_ProductDetailService implements IB2B2C_ProductDetailService { 
    
    public static B2B2C_ProductDetail.Response getProduct(B2B2C_ProductDetail.Request request) { 
		String webstoreId = B2CUtils.getWebstoreId(Network.getNetworkId());
        system.debug('webstoreId'+ webstoreId);
        system.debug('productId'+ request.productId);
        system.debug('effectiveAccountId'+ request.effectiveAccountId);
        
        if(String.isBlank(request.effectiveAccountId)){
            request.effectiveAccountId = B2CUtils.getAccountOrGuestBuyerProfileId();
        }         
        Product2 product = [
            Select Id, B2B2C_IsSubscription__c, ProductClass, B2B2C_Subscription_Metadata__c,
            (
                SELECT Id FROM Products__r
            ) 
            FROM Product2 WHERE Id =: request.productId
        ];
        
        if(product.ProductClass == 'Variation'){
            ProductAttribute[] productAttributes = [SELECT VariantParentId, ProductId FROM ProductAttribute Where ProductId = : request.productId];
            request.productId = productAttributes.size() > 0 && productAttributes[0].VariantParentId != null ? productAttributes[0].VariantParentId : request.productId;
            product = [
                Select Id, B2B2C_IsSubscription__c, ProductClass, B2B2C_Subscription_Metadata__c,
                (
                    SELECT Id FROM Products__r
                ) 
                FROM Product2 WHERE Id =: request.productId
            ];
        }
        
        system.debug('Products__r '+product.Products__r);
        B2B2C_ProductDetail.Response response;
        if(product.B2B2C_IsSubscription__c){
            response = getSubscriptionProduct(request, webstoreId);
        }else{
            response = getStandardProduct(request, webstoreId, new Map<Id, Product2>(product.Products__r).keySet());
        }
        
        if(String.isNotBlank(product.B2B2C_Subscription_Metadata__c)){
            Map<String, Object> metaData = (Map<String, Object>)JSON.deserializeUntyped(product.B2B2C_Subscription_Metadata__c);
            if(metaData.containsKey('feature')){
                response.feature = String.valueOf(metaData.get('feature'));
            }
            if(metaData.containsKey('subscribeDescription') && response.subscriptionDetail != null ){
                response.subscriptionDetail.subscribeDescription = String.valueOf(metaData.get('subscribeDescription'));
            }
            
        }
        return response;
    }
    
    public static B2B2C_ProductDetail.Response getSubscriptionProduct(B2B2C_ProductDetail.Request request, String webstoreId) {
        ConnectApi.ProductDetail product = ConnectApi.CommerceCatalog.getProduct(
            webstoreId, request.productId, request.effectiveAccountId, null, false, null, true, true, true
        );
        Map<String, String> productIdToAttributeName = new Map<String, String>();
        if(product != null && product.variationInfo != null && product.variationInfo.attributesToProductMappings != null && product.variationInfo.attributesToProductMappings.size() > 0){
            for(ConnectApi.ProductAttributesToProductEntry productAttributesToProductEntry :product.variationInfo.attributesToProductMappings){
                productIdToAttributeName.put(productAttributesToProductEntry.productId, productAttributesToProductEntry.canonicalKey);
            }
        }
        B2B2C_SubscriptionDetail subscriptionDetail;
        if(productIdToAttributeName.size() > 0){
        	Map<Id, Product2> variationProductMap = new Map<Id,Product2>([Select B2B2C_Subscription_Metadata__c FROM Product2 Where Id IN :productIdToAttributeName.keySet()]);
            List<ConnectApi.ProductOverview> variationProducts = getProducts(webstoreId, request.productId, request.effectiveAccountId, variationProductMap.keySet());
            subscriptionDetail = prepareSubscriptionDetail(productIdToAttributeName, variationProductMap, variationProducts);
        }
        return new B2B2C_ProductDetail.Response(product, null, null, true, subscriptionDetail);
    }
    
    public static B2B2C_SubscriptionDetail prepareSubscriptionDetail(Map<String, String> productIdToAttributeName, Map<Id, Product2> variationProductMap, List<ConnectApi.ProductOverview> variationProducts) {
        B2B2C_SubscriptionDetail subscriptionDetail = new B2B2C_SubscriptionDetail();
        subscriptionDetail.subscriptionOptions = new List<B2B2C_SubscriptionOption>();
		for(ConnectApi.ProductOverview productOverview :variationProducts){
            String metaDataStr = variationProductMap.get(productOverview.id)?.B2B2C_Subscription_Metadata__c;
            B2B2C_SubscriptionOption subscriptionOption = new B2B2C_SubscriptionOption();
            subscriptionOption.id = productOverview.id;
            subscriptionOption.intervalLabel = productIdToAttributeName.get(productOverview.id);
            if(productOverview.prices != null){
                subscriptionOption.listPrice = productOverview.prices.listPrice;
                subscriptionOption.unitPrice = productOverview.prices.unitPrice;                
            }
            
            if(String.isNotBlank(metaDataStr)){
            	Map<String, Object> metaData = (Map<String, Object>)JSON.deserializeUntyped(metaDataStr);
                if(metaData.containsKey('isOneTimePurchase') && Boolean.valueOf(metaData.get('isOneTimePurchase'))  == true){
                    subscriptionDetail.isOneTimePurchaseAllowed = true;
                    subscriptionDetail.oneTimePurchaseOption = subscriptionOption;
                }else if(metaData.containsKey('intervalTermUnit') && metaData.containsKey('intervalTerm')){
                    subscriptionOption.intervalTermUnit = String.valueOf(metaData.get('intervalTermUnit'));
                    subscriptionOption.intervalTerm = String.valueOf(metaData.get('intervalTerm'));
                    subscriptionDetail.subscriptionOptions.add(subscriptionOption);
                }
            }
        }
        return subscriptionDetail;
    }
    
    
    public static B2B2C_ProductDetail.Response getStandardProduct(B2B2C_ProductDetail.Request request, String webstoreId, Set<Id> relatedProductIds) {
        system.debug('relatedProductIds '+relatedProductIds);
        ConnectApi.ProductDetail product = ConnectApi.CommerceCatalog.getProduct(
            webstoreId, request.productId, request.effectiveAccountId, null, false, null, true, true, true
        );
        
        ConnectApi.ProductPrice price = ConnectApi.CommerceStorePricing.getProductPrice(webstoreId, request.productId, request.effectiveAccountId);
        List<ConnectApi.ProductOverview> relatedProducts = getProducts(webstoreId, request.productId, request.effectiveAccountId, relatedProductIds);
        return new B2B2C_ProductDetail.Response(product, price, relatedProducts, false, null);
    }
    
    public static List<ConnectApi.ProductOverview> getProducts(String webstoreId, String productId, String effectiveAccountId, Set<Id> relatedProductIds) {
        system.debug('relatedProductIds '+relatedProductIds);
        if( relatedProductIds.size() > 0){
            List<Id> productIds = new List<String>();
        	productIds.addAll(relatedProductIds);
            system.debug('productIds '+productIds);
            return ConnectApi.CommerceCatalog.getProducts(
                webstoreId,
                effectiveAccountId, 
                productIds,
                null,
                null,
                false,
                false
            )?.products;
        }else{
            return null;
        }
    }
    
    public static B2B2C_AddToCart.Response addToCart(B2B2C_AddToCart.Request request) {
        if(request.isSubscription != null && request.isSubscription){
            return addSubscriptionProductToCart(request);
        }else{
            return addStandardProductToCart(request);
        }
    }
    
    public static B2B2C_AddToCart.Response addSubscriptionProductToCart(B2B2C_AddToCart.Request request) {
        String webstoreId = B2CUtils.getWebstoreId(Network.getNetworkId());
        if(String.isBlank(request.effectiveAccountId)){
            request.effectiveAccountId = B2CUtils.getAccountOrGuestBuyerProfileId();
        } 
        
        addSubscriptionProductToCartValidation(webstoreId, request.effectiveAccountId, request.productId);
        
        ConnectApi.CartItemInput cartInput = new ConnectApi.CartItemInput();
        cartInput.productId = request.productId;
        cartInput.quantity = request.quantity;
        cartInput.type = ConnectApi.CartItemType.PRODUCT;
        ConnectApi.CartItem cartItem = ConnectApi.CommerceCart.addItemToCart(
            webstoreId, 
            request.effectiveAccountId, 
            'current', 
            cartInput
        );
        if(!(request.isOneTimePurchase != null && request.isOneTimePurchase)){
            Map<String, String> metaData = new Map<String, String>();
            metaData.put('intervalTermUnit', request.selectedSubscriptionOption.intervalTermUnit);
            metaData.put('intervalTerm', request.selectedSubscriptionOption.intervalTerm);
            metaData.put('isSubscription', 'true');
            metaData.put('numberOfDeliveries', String.valueOf(Integer.valueOf(request.numberOfDeliveries)) );
            CartItem cartItemObj = new CartItem(
            	Id = cartItem.cartItemId,
                B2B2C_Subscription_Metadata__c = JSON.serialize(metaData),
                B2B2C_IsSubscription__c = true
            );
            update cartItemObj;
            
        }
        B2B2C_AddToCart.Response response = new B2B2C_AddToCart.Response();
        //response.cartId = cart.cartId;
        response.success = true;
        return response;
    }
    
    public static void addSubscriptionProductToCartValidation(String webstoreId, String effectiveAccountId, String productId ) {
        ConnectApi.CartSummary cartSummary = ConnectApi.CommerceCart.getOrCreateActiveCartSummary(webstoreId, effectiveAccountId, 'current');
        ProductAttribute[] productAttributes = [SELECT VariantParentId FROM ProductAttribute Where ProductId = : productId];
        String variantParentId = productAttributes.size() > 0 ? productAttributes[0].VariantParentId : null;
        if(variantParentId != null){
            productAttributes = [SELECT ProductId FROM ProductAttribute Where VariantParentId = : variantParentId];
            List<String> variationProductIds = new List<String>();
            for(ProductAttribute productAttribute :productAttributes){
                if(productAttribute.ProductId != productId){
                    variationProductIds.add(productAttribute.ProductId);
                }
            }
            CartItem[] cartItems = [SELECT Id FROM CartItem WHERE CartId = :cartSummary.cartId AND Product2Id IN :variationProductIds];
            if(cartItems.size() > 0){
                throw new AuraHandledException('You already have this product in cart. If want to choose another subscription please remove existing subscription from the cart.');
            }
        }
    }
    
    public static B2B2C_AddToCart.Response addStandardProductToCart(B2B2C_AddToCart.Request request) {
        String webstoreId = B2CUtils.getWebstoreId(Network.getNetworkId());
        if(String.isBlank(request.effectiveAccountId)){
            request.effectiveAccountId = B2CUtils.getAccountOrGuestBuyerProfileId();
        } 
        system.debug(JSON.serializePretty(request));
        List<ConnectApi.BatchInput> batchList = new List<ConnectApi.BatchInput>();
        ConnectApi.CartItemInput cartInput = new ConnectApi.CartItemInput();
        cartInput.productId = request.productId;
        cartInput.quantity = request.quantity;
        cartInput.type = ConnectApi.CartItemType.PRODUCT;
        ConnectApi.BatchInput mainbatch = new ConnectApi.BatchInput(cartInput);
        batchList.add(mainbatch);
        
        if(request.relatedProductIds != null && request.relatedProductIds.size() > 0){
            for (String relatedProductId : request.relatedProductIds) {
                ConnectApi.CartItemInput cartInput1 = new ConnectApi.CartItemInput();
                cartInput1.productId = relatedProductId;
                cartInput1.quantity = request.quantity;
                cartInput1.type = ConnectApi.CartItemType.PRODUCT;
                ConnectApi.BatchInput relatedBatch = new ConnectApi.BatchInput(cartInput1);
                batchList.add(relatedBatch);
            }
        }
        
        ConnectApi.CommerceCart.addItemsToCart(
            webstoreId,
            request.effectiveAccountId,
            'current',
            batchList
        );
        
        //ConnectApi.CartSummary cart = ConnectApi.CommerceCart.getCartSummary(webstoreId, request.effectiveAccountId, 'active');
        B2B2C_AddToCart.Response response = new B2B2C_AddToCart.Response();
        //response.cartId = cart.cartId;
        response.success = true;
        return response;
    }
}