public class WishlistController {
    //class instance
     static  WishlistJsonToApexConverter obj=new WishlistJsonToApexConverter();
     static WishlistProductsJsonToApex WishlistProductResponce = new WishlistProductsJsonToApex();
     static list<string> productsToBeAddededInWishList;
     
    
    @AuraEnabled 
    public static string getProductCode(string ProductIdFromJs ,string UserIdFromJs){
        system.debug(ProductIdFromJs);
        user CurrentUser= [SELECT AccountId, Id, Name FROM User where id=:UserIdFromJs];
        string UserAccountId =CurrentUser.AccountId;
        string st=ProductIdFromJs;
        
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
        	String WishlistId ;
            if(summariesList.size()>0){
               Map<String, Object> summariesMap = (Map<String, Object>) summariesList[0];
               WishlistId  = (String) summariesMap.get('id');       
               
            }
        else{
            WishlistId=null;
        }
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
           // changed WishlistProductResponce =(WishlistProductsJsonToApex) System.JSON.deserialize(responseP.getBody(), WishlistProductsJsonToApex.class);
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
            if(productIds.contains(ProductIdFromJs)){
                return 'Product Is Already added TO wishLis';
            }
            System.debug('Product IDs: ' + productIds);
        }
          
        
        //code for creating the wishlist and 1st product Adding
                if (obj.wishlistCount == 0){
                       Map<String, Object> obj1= new Map<String, Object>{
                    'name' => 'wishlistof' + UserAccountId,
                    'products' => new List<Object>{
                        new Map<String, Object>{
                            'productId' => ProductIdFromJs
                        }
                    }
                           
                };
				String jsonBody = JSON.serialize(obj1);
                Http http1 = new Http();
                HttpRequest request1 = new HttpRequest();		
                request1.setEndpoint('callout:CallMeBack/services/data/v54.0/commerce/webstores/0ZE5i0000008gCIGAY/wishlists/?effectiveAccountId='+UserAccountId);
                request1.setMethod('POST');
                request1.setBody(jsonBody);
                request1.setHeader('Content-Type', 'application/json; charset=utf-8');
                HttpResponse response1 = http1.send(request1);
                system.debug('response ' + response1);
                system.debug('response body ' + response1.getBody());
                    return 'Wishlist is created and 1 st product to wishlist';
                    
        }   
        
        if(WishlistId !=null){
            Map<String, Object> obj2= new Map<String, Object>{
                'productId' => ProductIdFromJs
            };
            String jsonBody = JSON.serialize(obj2);
                Http http1 = new Http();
                HttpRequest request2 = new HttpRequest();		
                request2.setEndpoint('callout:CallMeBack/services/data/v54.0/commerce/webstores/0ZE5i0000008gCIGAY/wishlists/'+WishlistId+'/wishlist-items/?effectiveAccountId='+UserAccountId);
                request2.setMethod('POST');
                request2.setBody(jsonBody);
                request2.setHeader('Content-Type', 'application/json; charset=utf-8');
                HttpResponse response2 = http1.send(request2);
                system.debug('response ' + response2);
                system.debug('response body ' + response2.getBody());  
            return 'Product is added to Wishlist';
        }
        
  return 'WishlistProductResponce';
  }   
    
    @AuraEnabled 
    public static string CheckIfcodeProductisPresentOrNot(string ProductIdFromJs ,string UserIdFromJs){
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
			List<Object> summariesList = (List<Object>) parsedJson.get('summaries');String WishlistId ;
            if(summariesList.size()>0){
               Map<String, Object> summariesMap = (Map<String, Object>) summariesList[0];
               WishlistId  = (String) summariesMap.get('id');       
               
            }
        else{
            WishlistId= null;
        }
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
            WishlistProductResponce =(WishlistProductsJsonToApex) System.JSON.deserialize(responseP.getBody(), WishlistProductsJsonToApex.class);
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
            if(productIds.contains(ProductIdFromJs)){
                return 'yes';
            }
        return 'no';       
        } 
        return 'no';
    }
}