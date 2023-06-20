global without sharing class B2B2C_CartService implements IB2B2C_CartService  {
    
    global static B2B2C_Cart.Response getCartItems(B2B2C_Cart.Request request) {
        String webstoreId = B2CUtils.getWebstoreId(Network.getNetworkId());
        ConnectApi.CartItemCollection cartItemCollection = ConnectApi.CommerceCart.getCartItems(webstoreId, null, 'current');
        //ConnectApi.CartItem cartItem = (ConnectApi.CartItem)cartItemCollection.cartItems[0].cartItem;
        return createCartReponse(cartItemCollection);
    }
    
    global static B2B2C_Cart.Response createCartReponse(ConnectApi.CartItemCollection cartItemCollection) {
        if(cartItemCollection.hasErrors){
            return null;
        }
        
        Map<Id, B2B2C_CartItem> cartIdToCartItemWrap = new Map<Id, B2B2C_CartItem>();
        Map<Id, B2B2C_CartItem> productIdToCartItemWrap = new Map<Id, B2B2C_CartItem>();
        B2B2C_Cart.Response cart = new B2B2C_Cart.Response();
        cart.cartSummary = cartItemCollection.cartSummary;
        cart.cartItems = new List<B2B2C_CartItem>();
        for(ConnectApi.CartItemResult cartItemResult :cartItemCollection.cartItems){
            B2B2C_CartItem cartItemWrap = new B2B2C_CartItem();
            ConnectApi.CartItem cartItem = (ConnectApi.CartItem)cartItemResult.cartItem;
            cartItemWrap.cartId = cartItem.cartId;
            cartItemWrap.cartItemId = cartItem.cartItemId;
            cartItemWrap.productDetails = cartItem.productDetails;
            cartItemWrap.listPrice = cartItem.listPrice;
            cartItemWrap.quantity = cartItem.quantity;
            cartItemWrap.salesPrice = cartItem.salesPrice;
            cartItemWrap.totalAmount = cartItem.totalAmount;
            cartItemWrap.totalListPrice = cartItem.totalListPrice;
            cartItemWrap.totalPrice = cartItem.totalPrice;
            cartItemWrap.type = cartItem.type;
            cartItemWrap.unitAdjustedPrice = cartItem.unitAdjustedPrice;
            cart.cartItems.add(cartItemWrap);
            cartIdToCartItemWrap.put(cartItem.cartItemId, cartItemWrap);
            productIdToCartItemWrap.put(cartItem.productDetails.productId, cartItemWrap);
        }
        
        CartItem[] cartItems = [
            Select B2B2C_Subscription_Metadata__c, B2B2C_IsSubscription__c, Product2.B2B2C_Subscription_Metadata__c, Product2.B2B2C_Parent_Product__c
            FROM CartItem Where Id IN: cartIdToCartItemWrap.keySet() 
        ];
        
        List<String> subscriptionProductIds = new List<String>();
        
        for(CartItem cartItem :cartItems){
            B2B2C_CartItem cartItemWrap = cartIdToCartItemWrap.get(cartItem.Id);
            if(cartItem.B2B2C_IsSubscription__c){
                cartItemWrap.productClass = 'Deliverable Subscription';
                if(String.isNotBlank(cartItem.B2B2C_Subscription_Metadata__c)){
                    Map<String, Object> metaData = (Map<String, Object>)JSON.deserializeUntyped(cartItem.B2B2C_Subscription_Metadata__c);
                    B2B2C_SubscriptionOption subscriptionOption = new B2B2C_SubscriptionOption();
                    subscriptionOption.id = cartItem.Product2Id;
                    if(metaData.containsKey('intervalTermUnit') && metaData.containsKey('intervalTerm')){
                        subscriptionOption.intervalTermUnit = String.valueOf(metaData.get('intervalTermUnit'));
                        subscriptionOption.intervalTerm = String.valueOf(metaData.get('intervalTerm'));
                    }
                    if(metaData.containsKey('numberOfDeliveries')){
                        cartItemWrap.numberOfDeliveries = String.valueOf(metaData.get('numberOfDeliveries'));
                    }
                    if(metaData.containsKey('feature')){
                        cartItemWrap.feature = String.valueOf(metaData.get('feature'));
                    }
                    cartItemWrap.selectedOption = subscriptionOption; 
                }
                subscriptionProductIds.add(cartItemWrap.productDetails.productId);
            }else if(cartItem.Product2.B2B2C_Parent_Product__c != null){
                cartItemWrap.productClass = 'Related';
                cartItemWrap.parentProductId = cartItem.Product2.B2B2C_Parent_Product__c;
                if(productIdToCartItemWrap.containsKey(cartItemWrap.parentProductId)){
                    B2B2C_CartItem parentCartItemWrap = productIdToCartItemWrap.get(cartItemWrap.parentProductId);
                    if(parentCartItemWrap.relatedCartItemIds == null){
                        parentCartItemWrap.relatedCartItemIds = new List<String>();
                    }
                    parentCartItemWrap.relatedCartItemIds.add(cartItemWrap.cartItemId);
                }
                if(String.isNotBlank(cartItem.Product2.B2B2C_Subscription_Metadata__c)){
                    Map<String, Object> metaData = (Map<String, Object>)JSON.deserializeUntyped(cartItem.Product2.B2B2C_Subscription_Metadata__c);
                    if(metaData.containsKey('shortDescription')){
                        cartItemWrap.shortDescription = String.valueOf(metaData.get('shortDescription'));
                    }
                }
            }else{
                cartItemWrap.productClass = 'Simple';
                if(String.isNotBlank(cartItem.Product2.B2B2C_Subscription_Metadata__c)){
                    Map<String, Object> metaData = (Map<String, Object>)JSON.deserializeUntyped(cartItem.Product2.B2B2C_Subscription_Metadata__c);
                    if(metaData.containsKey('feature')){
                        cartItemWrap.feature = String.valueOf(metaData.get('feature'));
                    }
                }
            }
        }
        setSubscriptionOptions(subscriptionProductIds, productIdToCartItemWrap);
        return cart;
    }
    
    
    public static void setSubscriptionOptions(List<String> subscriptionProductIds, Map<Id, B2B2C_CartItem> productIdToCartItemWrap) {
        Set<String> variationParentIds = new Set<String>();
        Map<String, String> variatonToVariationParentId = new Map<String, String>();
        ProductAttribute[] productAttributes = [SELECT VariantParentId, ProductId FROM ProductAttribute Where ProductId IN : subscriptionProductIds];
        for(ProductAttribute productAttribute :productAttributes){
            variationParentIds.add(productAttribute.VariantParentId);
			variatonToVariationParentId.put(productAttribute.ProductId, productAttribute.VariantParentId);            
        }
        productAttributes = [SELECT VariantParentId, ProductId, Product.B2B2C_Subscription_Metadata__c, Delivery_Interval__c FROM ProductAttribute Where VariantParentId IN : variationParentIds];
        Map<String, B2B2C_SubscriptionOption[]> variationParentIdToSubscriptionOptions = new Map<String, B2B2C_SubscriptionOption[]>();
        for(ProductAttribute productAttribute :productAttributes){
            String metaDataStr = productAttribute.Product.B2B2C_Subscription_Metadata__c;
            B2B2C_SubscriptionOption subscriptionOption = new B2B2C_SubscriptionOption();
            subscriptionOption.id = productAttribute.ProductId;
            subscriptionOption.intervalLabel = productAttribute.Delivery_Interval__c;
            if(String.isNotBlank(metaDataStr)){
            	Map<String, Object> metaData = (Map<String, Object>)JSON.deserializeUntyped(metaDataStr);
                if(metaData.containsKey('isOneTimePurchase') && Boolean.valueOf(metaData.get('isOneTimePurchase'))  == true){
                    continue;
                }else if(metaData.containsKey('intervalTermUnit') && metaData.containsKey('intervalTerm')){
                    subscriptionOption.intervalTermUnit = String.valueOf(metaData.get('intervalTermUnit'));
                    subscriptionOption.intervalTerm = String.valueOf(metaData.get('intervalTerm'));
                }
            }
            
            if(variationParentIdToSubscriptionOptions.containsKey(productAttribute.VariantParentId)){
                variationParentIdToSubscriptionOptions.get(productAttribute.VariantParentId).add(subscriptionOption);
            }else{
                variationParentIdToSubscriptionOptions.put(productAttribute.VariantParentId, new List<B2B2C_SubscriptionOption>{subscriptionOption});
            }
        }
        
        for(String subscriptionProductId : subscriptionProductIds){
            String variationParentId = variatonToVariationParentId.get(subscriptionProductId);
            B2B2C_CartItem cartItem = productIdToCartItemWrap.get(subscriptionProductId);
            cartItem.subscriptionOptions = variationParentIdToSubscriptionOptions.get(variationParentId);
        }
    }
    
    /*public static B2B2C_SubscriptionOption[] getSubscriptionOptions(String subscriptionProductId) {
        String variationParentId;
        //Map<String, String> variatonToVariationParentId = new Map<String, String>();
        ProductAttribute[] productAttributes = [SELECT VariantParentId, ProductId FROM ProductAttribute Where ProductId = : subscriptionProductId];
        for(ProductAttribute productAttribute :productAttributes){
            variationParentId = productAttribute.VariantParentId;         
        }
        productAttributes = [SELECT VariantParentId, ProductId, Product.B2B2C_Subscription_Metadata__c, Delivery_Interval__c FROM ProductAttribute Where VariantParentId = : variationParentId];
        B2B2C_SubscriptionOption[] subscriptionOptions = new List<B2B2C_SubscriptionOption>();
        for(ProductAttribute productAttribute :productAttributes){
            String metaDataStr = productAttribute.Product.B2B2C_Subscription_Metadata__c;
            B2B2C_SubscriptionOption subscriptionOption = new B2B2C_SubscriptionOption();
            subscriptionOption.id = productAttribute.ProductId;
            subscriptionOption.intervalLabel = productAttribute.Delivery_Interval__c;
            if(String.isNotBlank(metaDataStr)){
            	Map<String, Object> metaData = (Map<String, Object>)JSON.deserializeUntyped(metaDataStr);
                if(metaData.containsKey('isOneTimePurchase') && Boolean.valueOf(metaData.get('isOneTimePurchase'))  == true){
                    continue;
                }else if(metaData.containsKey('intervalTermUnit') && metaData.containsKey('intervalTerm')){
                    subscriptionOption.intervalTermUnit = String.valueOf(metaData.get('intervalTermUnit'));
                    subscriptionOption.intervalTerm = String.valueOf(metaData.get('intervalTerm'));
                }
            }
            subscriptionOptions.add(subscriptionOption);
            
        }
        return subscriptionOptions;
    }*/
    
    global static B2B2C_Cart.Response deleteCartItem(B2B2C_DeleteCartItem.Request request) {
        String webstoreId = B2CUtils.getWebstoreId(Network.getNetworkId());
        if(String.isBlank(request.effectiveAccountId)){
            request.effectiveAccountId = B2CUtils.getAccountOrGuestBuyerProfileId();
        }   
        //ConnectApi.CommerceCart.deleteCartItem(webstoreId, request.effectiveAccountId, 'active', request.cartItemId);
        CartItem[] cartItemsToDelete = new List<CartItem>();
        cartItemsToDelete.add(new CartItem(Id = request.cartItemId));
        if(request.relatedCartItemIds != null && request.relatedCartItemIds.size() > 0){
            for(String relatedCartItemId :request.relatedCartItemIds){
                cartItemsToDelete.add(new CartItem(Id = relatedCartItemId));
            }
        }
        delete cartItemsToDelete;
        ConnectApi.CartItemCollection cartItemCollection = ConnectApi.CommerceCart.getCartItems(webstoreId, null, 'current');
        return createCartReponse(cartItemCollection);
    }
    
    global static B2B2C_Cart.Response updateCartItem(B2B2C_UpdateCartItem.Request request) {
        String webstoreId = B2CUtils.getWebstoreId(Network.getNetworkId());
        if(String.isBlank(request.effectiveAccountId)){
            request.effectiveAccountId = B2CUtils.getAccountOrGuestBuyerProfileId();
        }   
        
        if(request.productClass == 'Deliverable Subscription'){
            delete new CartItem(Id = request.cartItemId);
            B2B2C_AddToCart.Request addToCartRequest = new B2B2C_AddToCart.Request();
            addToCartRequest.productId = request.selectedOption.id;
        	addToCartRequest.quantity = request.quantity;
            addToCartRequest.isOneTimePurchase = false;
            addToCartRequest.selectedSubscriptionOption = request.selectedOption;
            addToCartRequest.numberOfDeliveries = request.numberOfDeliveries;
            B2B2C_ProductDetailService.addSubscriptionProductToCart(addToCartRequest);
        }else{
            ConnectApi.CartItemInput cartItemInput = new ConnectApi.CartItemInput();
            cartItemInput.quantity = request.quantity;
            ConnectApi.CommerceCart.updateCartItem(webstoreId, request.effectiveAccountId, 'current', request.cartItemId, cartItemInput);
            
            if(request.relatedCartItemIds != null && request.relatedCartItemIds.size() > 0){
                for(String relatedCartItemId :request.relatedCartItemIds){
                    ConnectApi.CommerceCart.updateCartItem(webstoreId, request.effectiveAccountId, 'current', relatedCartItemId, cartItemInput);
                }
            }
        }
        
        
        ConnectApi.CartItemCollection cartItemCollection = ConnectApi.CommerceCart.getCartItems(webstoreId, null, 'current');
        return createCartReponse(cartItemCollection);
    }
}