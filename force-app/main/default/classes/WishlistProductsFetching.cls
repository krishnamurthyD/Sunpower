public class WishlistProductsFetching {
     static  WishlistJsonToApexConverter obj=new WishlistJsonToApexConverter();
    static WishlistProductsJsonToApex WishlistProductResponce = new WishlistProductsJsonToApex();
    
    @AuraEnabled 
    public static List<Object> sendProductList(string UserIdFromJs){
        user CurrentUser= [SELECT AccountId, Id, Name FROM User where id=:UserIdFromJs];
        string UserAccountId =CurrentUser.AccountId;
         //HttP Request "GET" for checking the User is Having the Wishlist alredy or not
          	Http http=new Http();
			HttpRequest request = new HttpRequest();
			request.setEndpoint('callout:CallMeBack/services/data/v54.0/commerce/webstores/0ZE5i0000008gCIGAY/wishlists?effectiveAccountId='+UserAccountId);
			request.setMethod('GET');
			request.setHeader('Content-Type', 'application/json;  charset=utf-8');
			HttpResponse response = http.send(request);
			system.debug('response '+response);
			system.debug('response body '+response.getBody());
        //below code helpful for Delete wishlist Opera
            string jsonString =response.getBody();
			Map<String, Object> parsedJson = (Map<String, Object>) JSON.deserializeUntyped(jsonString);
			List<Object> summariesList = (List<Object>) parsedJson.get('summaries');
			Map<String, Object> summariesMap = (Map<String, Object>) summariesList[0];
			String WishlistId = (String) summariesMap.get('id');       
           obj=(WishlistJsonToApexConverter) System.JSON.deserialize(response.getBody(), WishlistJsonToApexConverter.class);
        
        // "Get" Request for get wishlist products
        if(WishlistId != null){
        Http HttpProducts=new Http();
			HttpRequest requestP= new HttpRequest();
			requestP.setEndpoint('callout:CallMeBack/services/data/v54.0/commerce/webstores/0ZE5i0000008gCIGAY/wishlists/'+WishlistId+'/wishlist-items?effectiveAccountId='+UserAccountId);
			requestP.setMethod('GET');
			requestP.setHeader('Content-Type', 'application/json;  charset=utf-8');
			HttpResponse responseP= HttpProducts.send(requestP);
			system.debug('response '+responseP);
			system.debug('response body '+responseP.getBody()); 
          // changed  WishlistProductResponce =(WishlistProductsJsonToApex) System.JSON.deserialize(responseP.getBody(), WishlistProductsJsonToApex.class);
            String jsonStr1= responseP.getBody();
            //Gettting the Responce And storing the productid in ProductId
            Map<String, Object> jsonObjP= (Map<String, Object>) JSON.deserializeUntyped(jsonStr1);
            List<Object> items = (List<Object>) jsonObjP.get('items');
            List<String> productIds = new List<String>();
            for (Integer i = 0; i < items.size(); i++) {
                Map<String, Object> itemMap = (Map<String, Object>) items[i];
                Map<String, Object> productSummary = (Map<String, Object>) itemMap.get('productSummary');
                String productId = (String) productSummary.get('productId');
                productIds.add(productId);
            }
        return items;       
        } 
        
        List<Object> st ;
        return st;
     }
    
    @AuraEnabled 
    public static string DeleteTheWishlistProduct(string ProductWishlistItemId ,string UserIdFromJs){
         user CurrentUser= [SELECT AccountId, Id, Name FROM User where id=:UserIdFromJs];
        string UserAccountId =CurrentUser.AccountId;
         //HttP Request "GET" for checking the User is Having the Wishlist alredy or not
          	Http http=new Http();
			HttpRequest request = new HttpRequest();
			request.setEndpoint('callout:CallMeBack/services/data/v54.0/commerce/webstores/0ZE5i0000008gCIGAY/wishlists?effectiveAccountId='+UserAccountId);
			request.setMethod('GET');
			request.setHeader('Content-Type', 'application/json;  charset=utf-8');
			HttpResponse response = http.send(request);
			system.debug('response '+response);
			system.debug('response body '+response.getBody());
        //below code helpful for Delete wishlist Opera
            string jsonString =response.getBody();
			Map<String, Object> parsedJson = (Map<String, Object>) JSON.deserializeUntyped(jsonString);
			List<Object> summariesList = (List<Object>) parsedJson.get('summaries');
			Map<String, Object> summariesMap = (Map<String, Object>) summariesList[0];
			String WishlistId = (String) summariesMap.get('id');       
           obj=(WishlistJsonToApexConverter) System.JSON.deserialize(response.getBody(), WishlistJsonToApexConverter.class);
        
        //Delete the wishlistitem
        Http httpD=new Http();
			HttpRequest requestD = new HttpRequest();
			requestD.setEndpoint('callout:CallMeBack/services/data/v54.0/commerce/webstores/0ZE5i0000008gCIGAY/wishlists/'+WishlistId+'/wishlist-items/'+ProductWishlistItemId+'?effectiveAccountId='+UserAccountId);
			requestD.setMethod('DELETE');
			requestD.setHeader('Content-Type', 'application/json;  charset=utf-8');
			HttpResponse responseD = httpD.send(requestD);
			system.debug('response '+responseD);
			system.debug('response body '+responseD.getBody());
        
        
        return responseD.getBody();
    }
        @AuraEnabled 
    public static string AddtheProductToWishlist(string ProductIdToBeaddedToAddToCart ,string UserIdFromJs){
       system.debug(UserIdFromJs);
        String AccountIdStorer;
   		string UserIdAndOwnerIDBotharesame;
      	string CartIdStorer;
        String accountIdofCart;

        
        //
        User currentUser =[SELECT AccountId, Id FROM User WHERE Id =:UserIdFromJs];
         //  storing the current Login Account id 
         //  user id and ownerid both are same
         AccountIdStorer = currentUser.id;
        
        system.debug(AccountIdStorer);

        UserIdAndOwnerIDBotharesame = currentUser.AccountId;
        system.debug(UserIdAndOwnerIDBotharesame);
        
           
           //checking for cart
           List<WebCart> carts = [SELECT Id,AccountId FROM WebCart WHERE accountid =: UserIdAndOwnerIDBotharesame and  ownerId =:  AccountIdStorer  And status IN ('active','checkout')];
            system.debug(carts);
          
         if (carts.size() > 0) {
        	 for (WebCart cart : carts) {
    			 CartIdStorer= cart.Id;
   				 accountIdofCart = cart.AccountId;
           }
          }
        
          
        else {     
            /*24-05-23
           list<WebCart> webcarts= [select Accountid,ownerid,id,status from webcart where accountid='0015i00000YDaBMAA1' and ownerId='0055i000007eNIkAAM' and status='pendingDelete'];
			system.debug(webcarts[0]);
             webcarts[0].status= 'active';
            webcarts.update(); */
           // Savepoint sp = Database.setSavepoint();

try {
    WebCart cart = new WebCart(Name='Cart', WebStoreId='0ZE5i0000008gCIGAY', AccountId=UserIdAndOwnerIDBotharesame);
    insert cart;
    System.debug(cart);
    
    //Perform additional operations if needed
    
   // Database.rollback(sp);
} catch (Exception e) {
    System.debug('An error occurred: ' + e.getMessage());
}
            
            
           /* WebCart cart = new WebCart(Name='Cart', WebStoreId='0ZE5i0000008gCIGAY', AccountId=UserIdAndOwnerIDBotharesame);
        insert cart;
system.debug(cart);
          
          /* Webcart webcart=new WebCart();
            webcart.Name='cart';
            webcart.Status='active';
            webcart.WebStoreId='0ZE5i0000008gCIGAY';
            webcart.OwnerId=AccountIdStorer;
            webcart.AccountId=UserIdAndOwnerIDBotharesame;
            try {
    			insert webcart;
    			System.debug('WebCart object inserted successfully with Id: ' + webcart.Id);
			} catch (Exception e) {
                System.debug('Failed to insert WebCart object: ' + e.getMessage());
            }
            //insert webcart;
            /*Webcart[] webcart =new List<Webcart>{
                new webcart(Status='active',OwnerId=AccountIdStorer,AccountId=UserIdAndOwnerIDBotharesame)
            };
            Database.SaveResult[] results = Database.insert(webcart, false);
            for (Database.SaveResult result : results) {
            if (result.isSuccess()) {
                //Successfully inserted
                //Handle insertion
                System.debug('Account Successfully inserted, Account Id is: ' + result.getId());
            }
            else {
                //Error ecountered              
                for(Database.Error error : result.getErrors()) {
                    //Handle error
                     System.debug(error.getStatusCode() + ': ' + error.getMessage() + 
                                  ' Fields that affected the error: ' + error.getFields());
        
                }
            }
        }*/
           // if (webcart.Id != null) {
           //    System.debug('WebCart object inserted successfully with Id: ' + webcart.Id);
             //  } else {
               //   System.debug('Failed to insert WebCart object');
                 // }
            List<WebCart> carts1 = [SELECT Id,AccountId FROM WebCart WHERE accountid =: UserIdAndOwnerIDBotharesame and  ownerId =:  AccountIdStorer  And status IN ('active','checkout')];
            system.debug(carts);
          
         if (carts1.size() > 0) {
        	 for (WebCart cart1 : carts1) {
    			 CartIdStorer= cart1.Id;
   				 accountIdofCart = cart1.AccountId;
           }
         }/*
        
              Map<string ,object> obj1 =new Map<string ,Object>{
                  'name'=>'cart',
                   'type'=>'cart'
              };
              String jsonBody = JSON.serialize(obj1);
              
               Http http1 = new Http();
                HttpRequest request1 = new HttpRequest();	
              Map<String,Object> objc=new Map<string,object>();
              objc.put('effectiveAccountId',UserIdAndOwnerIDBotharesame);
                request1.setEndpoint('callout:CallMeBack/services/data/v56.0/commerce/webstores/0ZE5i0000008gCIGAY/carts');
                request1.setMethod('GET');
                 request1.setBody(JSON.serialize(objc));
              //  request1.setBody(jsonBody);
                request1.setHeader('Content-Type', 'application/json; charset=utf-8');
                HttpResponse response1 = http1.send(request1);
                system.debug('response ' + response1);
                system.debug('response body ' + response1.getBody());
              
             List<WebCart> cartsone = [SELECT Id,AccountId,status FROM WebCart WHERE accountid =: UserIdAndOwnerIDBotharesame];
            system.debug(cartsone);
              if (cartsone.size() > 0) {
              for (WebCart cart : cartsone) {
                  if(cart.Status == 'active'){
    			 CartIdStorer= cart.Id;
   				 accountIdofCart = cart.AccountId;
                  }
              }
              }*/
              //end
              
            // CartIdStorer= newCart.Id;
              system.debug(cartIdStorer);
           // makeCalloutAsync(ProductIdToBeaddedToAddToCart,CartIdStorer,UserIdAndOwnerIDBotharesame);
          }
     
           Http http = new Http();
            HttpRequest request = new HttpRequest();
			Map<String,Object> obj = new Map<String,Object>();
            obj.put('productId',ProductIdToBeaddedToAddToCart);
            obj.put('quantity','1');
            obj.put('type','product');
            //We have to add the 1)Web-Site-id And 2)Cart And 3)AccountId in place of + symbol 
            request.setEndpoint('callout:CallMeBack/services/data/v54.0/commerce/webstores/' + '0ZE5i0000008gCIGAY' + '/carts/'+ CartIdStorer + '/cart-items?effectiveAccountId='+ UserIdAndOwnerIDBotharesame);
            request.setMethod('POST');
            request.setBody(JSON.serialize(obj));
            request.setHeader('Content-Type', 'application/json;  charset=utf-8');
            HttpResponse response = http.send(request);
            system.debug('response '+response);
            system.debug('response body '+response.getBody());  
        
                 
        return 'ok';
    }
    @future(callout=true)
    public static void makeCalloutAsync(string ProductIdToBeaddedToAddToCart, string CartIdStorer, string UserIdAndOwnerIDBotharesame) {
    Http http = new Http();
    HttpRequest request = new HttpRequest();
    Map<String, Object> obj = new Map<String, Object>();
    obj.put('productId', ProductIdToBeaddedToAddToCart);
    obj.put('quantity', '1');
    obj.put('type', 'product');
    
    // Replace the + symbols with the actual values in the endpoint URL
    String endpoint = 'callout:CallMeBack/services/data/v54.0/commerce/webstores/0ZE5i0000008gCIGAY/carts/' + CartIdStorer + '/cart-items?effectiveAccountId=' + UserIdAndOwnerIDBotharesame;
    
    request.setEndpoint(endpoint);
    request.setMethod('POST');
    request.setBody(JSON.serialize(obj));
    request.setHeader('Content-Type', 'application/json; charset=utf-8');
    
    HttpResponse response = http.send(request);
    system.debug('response: ' + response);
    system.debug('response body: ' + response.getBody());
}
}