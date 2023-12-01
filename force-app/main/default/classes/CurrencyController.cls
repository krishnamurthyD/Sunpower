public without sharing class CurrencyController {
    //get the currency list to show in website 
    @AuraEnabled(cacheable=true)
    public static string CountryCurrencyName(){
        return system.label.Country_Currency;
    }
    
     //get the currency of user 
    @AuraEnabled
    public static string currentUserCurrency(string userId){
        user userdetails =[select AccountId,DefaultCurrencyISOCode,CurrencyISOCode from USER where Id =:userId];
        account acc =[select id ,CurrencyIsoCode from account where id=:userdetails.AccountId];
        return acc.CurrencyIsoCode;
    }
    
    //changing the site currency 
    @Auraenabled
    public static void logInuserlang(string locale, string userId,string communityid){
        String item2Json;
        //id netid = [SELECT Id, NetworkId, IsActive FROM Community where Id =:communityid].NetworkId;
        id storeid =[SELECT Id, Name, WebStoreId, NetworkId FROM WebStoreNetwork WHERE NetworkId =: communityid].WebStoreId;
        //list<webcart> cart2 = new list<webcart>();
        system.debug('locale - ' + locale);
        user userdetails =[select AccountId,DefaultCurrencyISOCode,CurrencyISOCode from USER where Id =: userId];
        system.debug('accId'+userdetails.AccountId);
        Account acc = new Account();
        acc.id =userdetails.AccountId;
        if(locale == 'USD'){
            acc.CurrencyIsoCode = 'USD';
            userdetails.DefaultCurrencyISOCode ='USD';
        }
        else if(locale == 'EUR'){
            acc.CurrencyIsoCode = 'EUR';
            userdetails.DefaultCurrencyISOCode ='EUR';
        }
        else{
           
             acc.CurrencyIsoCode = 'GBP ';
            userdetails.DefaultCurrencyISOCode ='GBP ';
        }

        system.debug('acc'+acc);
        system.debug('userdetails'+userdetails);
       // system.debug('cart2'+cart2);
        Update userdetails;
        Update acc;
        
         //Custom label for tax used in store
        String TaxUsed = system.label.TaxName;
        
        list<WebCart> carts1 = new list<WebCart>();
        list<CartItem> item2 = new list<CartItem>();
       list<WebCart> cartdetails1=[SELECT Id, CurrencyIsoCode, Name, AccountId, Status, IsSecondary, TotalAdjustmentAmount, GrandTotalAmount, CreatedDate,(SELECT Id,Product2Id, 
                                  Name,Quantity FROM CartItems where Name !=:TaxUsed ) FROM WebCart where (Status ='Active' or Status='Checkout') and AccountId =:userdetails.AccountId];
       system.debug(cartdetails1);
        if(!cartdetails1.isEmpty()){
        for(WebCart secondarycart:cartdetails1){
            for(CartItem items:secondarycart.CartItems){
                CartItem item1 = new CartItem();
                item1.Product2Id=items.Product2Id;
                item1.Quantity=items.Quantity;
                item2.add(item1);
            }
            Delete cartdetails1;
        }
           item2Json = JSON.serialize(item2);
            createcart(storeid,locale,userdetails.AccountId,item2Json);
        }
        
            
           /* if(secondarycart.CurrencyIsoCode != locale){
                secondarycart.IsSecondary=true;
                carts1.add(secondarycart);
            }*/
            
        
       /* if(!carts1.isEmpty()){
            update carts1;
        }*/
        
       // AccountDetailsForTheGuestUse(userId,locale);
        
   }  
     @future
    @Auraenabled
    public static void createcart(string storeid,string locale,string accountid, String itemsJson){   
         List<CartItem> items = (List<CartItem>)JSON.deserialize(itemsJson, List<CartItem>.class);
        system.debug(items);
ConnectApi.CartSummary a;
ConnectApi.CartInput cart1 = new ConnectApi.CartInput();
cart1.CurrencyIsoCode=locale;
system.debug(cart1.currencyIsoCode);
cart1.effectiveAccountId=accountid;
cart1.name='cart'+ locale;

        //cart1.isSecondary=true;
a=ConnectApi.commerceCart.createCart(storeid,cart1);
        cartitems(storeid,locale,accountid,items);
    }
    
    public static ConnectApi.BatchResult[] cartitems(string storeid,string locale,string accountid,List<CartItem> itemslist){
        ConnectApi.BatchResult[] a;
        id cartid=[SELECT Id, Name, Status, Type, CurrencyIsoCode, AccountId,WebStoreId FROM WebCart where Status='Active' and CurrencyIsoCode=:locale and  AccountId=:accountid and WebStoreId =:storeid].Id;
       // ConnectApi.CartItemType protype='Product';
        List<ConnectApi.BatchInput> cartItems = new List<ConnectApi.BatchInput>();
        //list<ConnectApi.CartItemInput> item = new list<ConnectApi.CartItemInput>();
        ConnectApi.CartItemInput items = new ConnectApi.CartItemInput();
        system.debug(itemslist.size());
        for(integer i=0;i<itemslist.size();i++){
            CartItem proitems = itemslist[i];
       // for(CartItem proitems:itemslist){
           items.productId=proitems.Product2Id;
           items.quantity=String.valueOf(proitems.Quantity);
        items.type= ConnectApi.CartItemType.Product; 
         ConnectApi.BatchInput batchInput = new ConnectApi.BatchInput(items);
       cartItems.add(batchInput);
             system.debug(cartItems);
        a=ConnectApi.commerceCart.addItemsToCart(storeid, accountid, cartid,
                                                cartItems, locale);
       // }
       system.debug(cartItems);
       cartItems.clear();
  
        }
       
            return a;
    }
    
    //method for checking for new cart
    @Auraenabled
    public static Webcart getNewCartDetails(id userid){
         user userdetails =[select AccountId,DefaultCurrencyISOCode,CurrencyISOCode from USER where Id =:userId];
        try{
            Webcart cartid=[SELECT Id, Name, Status, Type, CurrencyIsoCode, AccountId,WebStoreId FROM WebCart where Status='Active' and AccountId=:userdetails.accountid];
        If(cartid.id != null){
            return cartid;
        }
        }
            catch(exception e){
              return null;
            }
       
        return null;        
    }
        
    
        
    }