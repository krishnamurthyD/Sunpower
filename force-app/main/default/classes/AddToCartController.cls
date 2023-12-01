public class AddToCartController {
     public static String AccountIdStorer;
     public static string CartIdStorer;
      @AuraEnabled(cacheable=true)
       public static void getUserInfo() {
       User currentUser =[SELECT Id,Name FROM User WHERE Id = :UserInfo.getUserId()];
           //storing the current Login Account id
           AccountIdStorer = currentUser.Id;
           
           //checking for cart
           List<WebCart> carts = [SELECT Id, Name FROM WebCart WHERE AccountId = :AccountIdStorer];
          // Check if the Account has a Cart
         if (carts.size() > 0) {
        // If the Account has a Cart, store it in a variable
          WebCart myCart = carts[0];
             CartIdStorer=myCart.Id;
          System.debug('Cart Id: ' + myCart.Id);
          } else {
          // If the Account does not have a Cart, create a new one and store it in a variable
        WebCart newCart = new WebCart(AccountId = AccountIdStorer, Name = 'My New Cart');
           insert newCart;
           System.debug('New Cart Id: ' + newCart.Id);
             CartIdStorer= newCart.Id;
          }
       }
     @AuraEnabled
    public static string matchProducts(List<string> SkuId) {
        //system.debug(SkuId);
       // list<product2> productsToBeAddedToCart = new list<product2>();
        list<string> ProductIds = new list<string>();
        list<product2> productToBeFetched = new list<product2>();
         productToBeFetched  =[SELECT ProductCode FROM Product2 where productCode != null];
        
        //converting the productcode to string 
        List<String> productCodes = new List<String>();
		for (Product2 prod : productToBeFetched) {
             productCodes.add(prod.ProductCode);
           }
        //checking the entryed skue is availabel or not
        for(string s1 : SkuId) {
            for(string s2 : productCodes ){
                if(s1==s2){
                    ProductIds.add(s1);
                }
            }
        }
        list<string> stringone =new list<string>();
        list<Product2> ProductCOdeToIs= [SELECT Id FROM Product2 where productCode  =: ProductIds];
        for (product2 pro :ProductCOdeToIs){
            stringone.add(pro.id);
        }
        for(string st : stringone){
            Http http = new Http();
            HttpRequest request = new HttpRequest();
			Map<String,Object> obj = new Map<String,Object>();
            obj.put('productId',st);
            obj.put('quantity','25');
            obj.put('type','product');
            //We have to add the 1)Web-Site-id And 2)Cart And 3)AccountId in place of + symbol 
            request.setEndpoint('callout:PumaDemoStore/services/data/v54.0/commerce/webstores/' + '0ZE3z000000TN1KGAW' + '/carts/'+ CartIdStorer + '/cart-items?effectiveAccountId='+ AccountIdStorer);
            request.setMethod('POST');
            request.setBody(JSON.serialize(obj));
            request.setHeader('Content-Type', 'application/json;  charset=utf-8');
            HttpResponse response = http.send(request);
            system.debug('response '+response);
            system.debug('response body '+response.getBody());          
        }
       // system.debug(ProductIds);
       // productsToBeAddedToCart= [SELECT Id, Name, Description,ProductCode FROM Product2 WHERE ProductCode IN :ProductIds];
        //system.debug(productsToBeAddedToCart);
        return 'ok';
    }
  

}