public with sharing class AddToWishListControllerTwo {
    
    //Add products to wishlist
    @AuraEnabled
    public static List <WishListItem> createWishList(String currentUserId,String currentCommunityId,String productId){
        List<WishList> wishListFinal = new List<WishList>();
        
        Id userWebStoreId = [SELECT WebStoreId FROM WebStoreNetwork WHERE NetworkId = :currentCommunityId LIMIT 1].WebStoreId;
        Id userAccountId =  [SELECT AccountId FROM User WHERE Id = :currentUserId LIMIT 1].AccountId;
        List<WishList> existingWishLists = [SELECT Id FROM WishList
                                            WHERE WebStoreId = :userWebStoreId
                                            AND AccountId = :userAccountId
                                            AND OwnerId = :currentUserId
                                            ORDER BY CreatedDate DESC
                                            LIMIT 1];
        if (existingWishLists.isEmpty()) {
            system.debug('Empty');
            // Create a new wishlist if none exists
            WishList newWishList = new WishList();
            newWishList.WebStoreId = userWebStoreId;
            newWishList.AccountId = userAccountId;
            newWishList.OwnerId = currentUserId;
            newWishList.Name = 'Wishlist';
            insert newWishList;
            
            wishListFinal.add(newWishList);
        } else {
            wishListFinal = existingWishLists;
            system.debug('Already Present');
        }
        
        
        //Check Whether Product Is Already In Wish List
        List<WishListItem> existingWishListItems = [SELECT Product2Id FROM WishListItem WHERE 
                                                    WishListId=:wishListFinal[0].Id AND
                                                    Product2Id=:productId LIMIT 1];
        
        if(existingWishListItems.isEmpty()){
            //Instert product in wishlist 
            WishListItem wItem = new WishListItem();
            wItem.WishListId = wishListFinal[0].Id;
            wItem.Product2Id = productId;
            wItem.Name = 'Product';
            insert wItem;
        }
        
        
        
        
        
        List <WishListItem> totalWishListItem = [SELECT Name, Product2Id,WishListId FROM WishListItem  WHERE WishListId=:wishListFinal[0].Id LIMIT 20];       	
        System.debug('WishListItem'+totalWishListItem);
        return totalWishListItem;
    }
    
    //Move products from wishlist to cart
    @AuraEnabled
    public static List <CartItem> moveProductToCart(String currentUserId,String currentCommunityId,String productId){
        
        List<WebCart> webCartFinal = new List<WebCart>();
        Id userWebStoreId = [SELECT WebStoreId FROM WebStoreNetwork WHERE NetworkId = :currentCommunityId LIMIT 1].WebStoreId;
        Id userAccountId =  [SELECT AccountId FROM User WHERE Id = :currentUserId LIMIT 1].AccountId;
        List<WebCart> existingWebCarts = [SELECT Id FROM WebCart
                                            WHERE WebStoreId = :userWebStoreId
                                            AND AccountId = :userAccountId
                                            AND CreatedById = :currentUserId
                                            ORDER BY CreatedDate DESC
                                            LIMIT 1];
        
        if (existingWebCarts.isEmpty()) {
            system.debug('Empty');
            //Create a new wishlist if none exists
            WebCart newWebCart = new WebCart();
            newWebCart.WebStoreId = userWebStoreId;
            newWebCart.AccountId = userAccountId;
            newWebCart.OwnerId = currentUserId;
            newWebCart.Name = 'WebCart';
            insert newWebCart;
            
            webCartFinal.add(newWebCart);
        } 
        else 
        {
            webCartFinal = existingWebCarts;
            system.debug('Already Present');
        }
        
        
        //Check product is already in cart ot not
        List<CartItem> existingCartItems = [SELECT Product2Id FROM CartItem WHERE 
                                                    CartId=:webCartFinal[0].Id AND
                                                    Product2Id=:productId LIMIT 1];
        
            
        
        if(existingCartItems.isEmpty()){
            
            //Associate CartDeliveryGroup Id For Cart Item
           List<CartDeliveryGroup> existingCartDeliveryGroup=[SELECT Id FROM CartDeliveryGroup WHERE CartId=:webCartFinal[0].Id];
           if(existingCartDeliveryGroup.IsEmpty()){
            CartDeliveryGroup ct=new CartDeliveryGroup();
            ct.CartId=webCartFinal[0].Id;
            ct.Name='Default Delivery';
            insert ct;
            existingCartDeliveryGroup.add(ct);
           }
            
            
            //Instert product in CartItem 
            CartItem nCartItem = new CartItem();
            nCartItem.CartId = webCartFinal[0].Id;
            nCartItem.CartDeliveryGroupId=existingCartDeliveryGroup[0].Id;
            nCartItem.Product2Id = productId;
            nCartItem.Name = 'Product';
            insert nCartItem;
           
        }
        //delete product from wishlist
        List<WishList> existingWishLists = [SELECT Id FROM WishList
                                            WHERE WebStoreId = :userWebStoreId
                                            AND AccountId = :userAccountId
                                            AND OwnerId = :currentUserId
                                            ORDER BY CreatedDate DESC
                                            LIMIT 1];
        List<WishListItem>tempWishListItem=[SELECT Id FROM WishListItem WHERE WishListId=:existingWishLists[0].Id AND Product2Id=:productId];
        delete tempWishListItem;
        List<CartItem> totalCartItems=[SELECT Id,Name,Product2Id from CartItem WHERE CartId=:webCartFinal[0].Id];
        system.debug('Total Cart Items'+ totalCartItems);
        return totalCartItems;
        
    }
}