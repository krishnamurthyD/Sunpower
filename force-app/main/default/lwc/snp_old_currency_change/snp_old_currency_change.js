/**
 * @description          On Hover Image With Discription #tiles
 * @Author               Krishnamurthy Donta
 * @Createddate          19-06-2023
 * @ControllerClass      
 * @TestClass            
 * @modificationSummary  Nameofmodifier - modification date - modifications made
 */

import { LightningElement, track ,wire} from 'lwc';
import multiCurrencyIconImage from '@salesforce/resourceUrl/multiCurrencyIconImage';
import usaDollerIcon from '@salesforce/resourceUrl/usaDollerIcon';
import euroCurrencyIcon from '@salesforce/resourceUrl/euroCurrencyIcon';
import gbpCurrencyIcon from '@salesforce/resourceUrl/gbpCurrencyIcon';
import userlang from '@salesforce/apex/CurrencyController.logInuserlang';
import currentUserCurrency from '@salesforce/apex/CurrencyController.currentUserCurrency';
import CountryCurrencyName from '@salesforce/apex/CurrencyController.CountryCurrencyName';
import removeCartProductsAndMakecartAsClosed from '@salesforce/apex/CurrencyController.removeCartProductsAndMakecartAsClosed';
import checkingcustemetHavingCartOrNot from '@salesforce/apex/CurrencyController.checkingcustemetHavingCartOrNot';
import guestUser from '@salesforce/user/isGuest';
import UserId from '@salesforce/user/Id';
import { NavigationMixin } from 'lightning/navigation';


export default class Snp_old_currency_change extends NavigationMixin(LightningElement) {
  usaDollerIconStaticResource = usaDollerIcon;
  euroCurrencyIconStaticResource = euroCurrencyIcon;
  gbpCurrencyIconStaticResource = gbpCurrencyIcon;
  @track multiCurrencyIconImageIMage = multiCurrencyIconImage
  @track showPicklist = false;
  @track selectedCurrency;
  @track selectedLanguageCode;
  @track checkuser=true;
  @track currencyList = [];
  @track isShowModalGuest = false;
  @track isShowModalRegister = false;
  @track cartremoved = 'Yes';
  @track showLoader =false;
  @track runForEmptycart = false;
  @track currencyListWithIcons=[];
  userCurrency = '';


  renderedCallback(){
    console.log('RenderCAllBack-UserId ----------->'+UserId);
    console.log('RenderCAllBack-GuestUser ----------->'+guestUser);

    //geting the current user currencyiso code
    currentUserCurrency({ userId: UserId })
    .then((result) => {
      console.log( 'currenct user iso--->',result);
      this.userCurrency = result;
      console.log(targetLists);
      console.log('ok----------->');
    })
    .catch((error) => {
      console.log('currenct user iso--->',error);
    });
  }
  

 

  //checkweather the user is having the cart or not
  cartcheck(){
    checkingcustemetHavingCartOrNot({userid:UserId})
  .then((result)=>{
    console.log(result);
    if(result == 'YES'){
      this.showLoader=false;
      this.isShowModalRegister = true;
    }else{
      this.showLoader=true;
      this.runForEmptycart = true;
      this.ChangeCurrency();

    }
  })
  .catch((error)=>{
    console.log(error);
  })
  }

  //Hiding the picklist
  hidePickList(){
    setTimeout(() => { this.showPicklist = false;  }, 300);
  }

  //model Will open and accourding to the user type.
  showModelforGuestForRegister(event){
    this.selectedLanguageCode = event.currentTarget.innerText;
    this.selectedLanguageCode = this.selectedLanguageCode.trim();
    console.log(this.selectedLanguageCode);
    if(guestUser){
      this.isShowModalGuest = true;
      this.showPicklist = false;
    }else{
      this.showLoader=true;
      this.handleLanguageSelect();
      // this.cartcheck();
      // this.isShowModalRegister = true;
      this.showPicklist = false;
    }
  }
  
  //closing the model pop for register user.
  hideModalBoxRegister(){
    this.isShowModalRegister = false;
  }

  //closing the model pop for guest user.
  hideModalBoxGuest(){
    this.isShowModalGuest = false;
  }

  //Redirecting the guest user to LogIn user.
  LoginPageRedirection(){
    this[NavigationMixin.Navigate]({
      type: 'comm__namedPage',
      attributes: {
          name:'Login',
      }
    });
    this.isShowModalGuest = false;
  }
  //Redirecting the guest user to SighIn user.
  SignInPageRedirection(){
    this[NavigationMixin.Navigate]({
      type: 'comm__namedPage',
      attributes: {
          name:'Register',
      }
    });
    this.isShowModalGuest = false;
  }

  //get change currency name from org.
  @wire(CountryCurrencyName)
  getProductFAS({ error, data }) {
    if (error) {
      console.log('error--------------->', error);
    } else if (data) {
      console.log('Data------------------->'+data);
      this.currencyList = data.split(',') // Split the string using the comma and space as the delimiter
      console.log(JSON.stringify(this.currencyList));
      
      const currencyImageMap = {
        'USD': this.usaDollerIconStaticResource,
        'EUR': this.euroCurrencyIconStaticResource,
        'GBP': this.gbpCurrencyIconStaticResource,
        // Add more currency-image mappings as needed
      };
  
     
      for (let x of this.currencyList) {
        const currencyCode = x.trim(); // Trim whitespace characters
        if (currencyImageMap[currencyCode]) {
          var tempList = [{"image": "", "name": ""}];
          tempList[0].image = currencyImageMap[currencyCode];
          tempList[0].name = currencyCode;
          this.currencyListWithIcons.push([...tempList]);
        }
      }
      console.log('listoficons------------------>',JSON.stringify(this.currencyListWithIcons));
    }
  } 

  //show or hide currency list values
  togglePicklist(event) {
    //This line is used for applying the focus on the button when clicked
    event.currentTarget.focus();
    console.log('hello');
    console.log('---------->',guestUser);
    this.showPicklist = !this.showPicklist;
    console.log('---------------->',UserId);
    
    
    setTimeout(() => {
      // Code to be executed after the timeout (2000 ms) goes here
      let targetLists = this.template.querySelectorAll('.currencyOptions');
      console.log(targetLists);

      if(guestUser){
        console.log('ok----------->');
        for (let i = 0; i < targetLists.length; i++) {
          console.log(targetLists[i].innerText);
          if (targetLists[i].innerText === ' GBP') {
              targetLists[i].classList.add('selected-option');
          } else {
              if (targetLists[i].classList.contains('selected-option')) {
                  targetLists[i].classList.remove('selected-option');
              }
          }
        }
      }else{
        console.log('Happyb birthday :)');
         let targetLists = this.template.querySelectorAll('.currencyOptions');
          for (let i = 0; i < targetLists.length; i++) {
            console.log(targetLists[i].innerText);
            if (targetLists[i].innerText === ' '+this.userCurrency) {
                targetLists[i].classList.add('selected-option');
            } else {
                if (targetLists[i].classList.contains('selected-option')) {
                    targetLists[i].classList.remove('selected-option');
                }
            }
          }
        }
        
    }, 0);
    
  }

  //check user is having the cart or not
  handleLanguageSelect() {
  this.isShowModalRegister = false;
  this.showLoader = true;
  removeCartProductsAndMakecartAsClosed({userid:UserId,selectedCurrency:this.selectedLanguageCode})
  .then((result)=>{
    console.log('cartdeletedresult---------->',result);
    this.cartremoved = 'Done';
    this.ChangeCurrency();
  })
  .catch((error)=>{
    console.log('cartdeletederror---------->',error);
  })

  }
  
  //change user currency
  ChangeCurrency(){

    if(!guestUser){
      this.checkuser= true;
      console.log(this.selectedLanguageCode);
    userlang({locale :this.selectedLanguageCode, userId : UserId})
    .then((result)=>{
    this.showLoader = false;
    var url = window.location.href;
    window.location.href=url;
    window.location.href;
    console.log("result"+ result);
    })
    .catch((error)=>{
    console.log("error"+ error);
    })
      // if(this.cartremoved =='Done' || this.cartremoved =='Closed' || this.runForEmptycart){
       
      // }
  }else{
      this.checkuser= false;
  }
  }

  //close the model popup
  handleCancel(){
    isShowModalRegister= false;
  }
}




//apexcode

// public without sharing class CurrencyController {
//     //get the currency list to show in website 
//     @AuraEnabled(cacheable=true)
//     public static string CountryCurrencyName(){
//         return system.label.Country_Currency;
//     }
    
//      //get the currency of user 
//     @AuraEnabled
//     public static string currentUserCurrency(string userId){
//         user userdetails =[select AccountId,DefaultCurrencyISOCode,CurrencyISOCode from USER where Id =:userId];
//         account acc =[select id ,CurrencyIsoCode from account where id=:userdetails.AccountId];
//         return acc.CurrencyIsoCode;
//     }
    
//     //changing the site currency 
//     @Auraenabled
//     public static void logInuserlang(string locale, string userId){
//         //list<webcart> cart2 = new list<webcart>();
//         system.debug('locale - ' + locale);
//         user userdetails =[select AccountId,DefaultCurrencyISOCode,CurrencyISOCode from USER where Id =: userId];
//         system.debug('accId'+userdetails.AccountId);
//         Account acc = new Account();
//         acc.id =userdetails.AccountId;
//         if(locale == 'USD'){
//             acc.CurrencyIsoCode = 'USD';
//             userdetails.DefaultCurrencyISOCode ='USD';
//         }
//         else if(locale == 'EUR'){
//             acc.CurrencyIsoCode = 'EUR';
//             userdetails.DefaultCurrencyISOCode ='EUR';
//         }
//         else{
           
//              acc.CurrencyIsoCode = 'GBP ';
//             userdetails.DefaultCurrencyISOCode ='GBP ';
//         }

//         system.debug('acc'+acc);
//         system.debug('userdetails'+userdetails);
//        // system.debug('cart2'+cart2);
//         Update userdetails;
//         Update acc;
//           }
    
//     //Checking does user is having the active cart or not
//     @Auraenabled
//     public static string checkingcustemetHavingCartOrNot(string userid){
//         //User details
//         user userdetails =[select AccountId,DefaultCurrencyISOCode,CurrencyISOCode from USER where Id =:userid];
//         account acc =[select id ,CurrencyIsoCode from account where id=:userdetails.AccountId];
//         list<WebCart> cartList=[SELECT Id,Status FROM WebCart where AccountId =:userdetails.AccountId and CurrencyIsoCode=:acc.CurrencyISOCode and Status='Active'];
//         WebCart cartid = (cartList.isEmpty()) ? null : cartList[0];
//         //Condition for checking active cart or not.
//         if(cartid != null && cartid.Status == 'Active'){
//             return 'YES';
//         }else{
//             return 'NO';
//         }
//     }
    
//     //Checking does user is having the active cart or not
//  /*   @Auraenabled
//     public static string removeCartProductsAndMakecartAsClosed(string userid){
//         //User details
//         user userdetails =[select AccountId,DefaultCurrencyISOCode,CurrencyISOCode from USER where Id =:userid];
//         account acc =[select id ,CurrencyIsoCode from account where id=:userdetails.AccountId];
//         list<WebCart> cartList=[SELECT Id,Status FROM WebCart where AccountId =:userdetails.AccountId and CurrencyIsoCode=:acc.CurrencyISOCode and Status='Active'];
//         WebCart cartid = (cartList.isEmpty()) ? null : cartList[0];
//         //Condition for checking active cart or not.
//         if(cartid != null && cartid.Status == 'Active'){
//            list<cartItem> item = [SELECT CartId, Quantity, Name, Id FROM CartItem where CartId=:cartid.id];
//             delete item;
//             WebCart cart1 = new WebCart();
//             cart1.id=cartid.id;
//             cart1.Status = 'Closed';
//             update cart1;
//             system.debug(cart1.id);
//             system.debug(item);
//             return cart1.Status;
//         }else{
//             return 'No';
//         }
//     }*/
//     //changing the cart currency and cart Items currency (productcurrency)
//     @Auraenabled
// 	public static void removeCartProductsAndMakecartAsClosed(string userid ,string selectedCurrency){
//         /*decimal totalProducts = 0;
//         decimal uniqueProducts = 0;
//         decimal prodquantity=0;
//          map<string,list<CartItem>> m1 = new map<string,list<CartItem>>();
//         user userdetails =[SELECT AccountId,DefaultCurrencyISOCode,CurrencyISOCode FROM USER WHERE Id =:userid];
//         account acc =[SELECT id ,CurrencyIsoCode FROM account WHERE id=:userdetails.AccountId];
//            system.debug(userdetails.AccountId);
//         list<WebCart> cartid=[SELECT Id,CurrencyISOCode,TotalProductCount,UniqueProductCount,
//                               (SELECT Id,Product2Id, Name,Quantity, CurrencyISOCode,Sku, AdjustmentAmount, SalesPrice,TotalAmount, 
//                                TotalLineNetAmount, TotalLineGrossAmount, TotalPriceAfterAllAdjustments, TotalLineAmount, TotalListPrice, 
//                                TotalPrice, UnitAdjustedPrice FROM CartItems),
//                               (SELECT CartId, CurrencyIsoCode, Name, Id FROM CartDeliveryGroups) 
//                               FROM WebCart
//                               WHERE AccountId =:userdetails.AccountId
//                               AND CurrencyIsoCode=:acc.CurrencyIsoCode];
//         system.debug(cartid);
//         list<WebCart> cart1 = new list<WebCart>();
//         list<CartItem> itemlist = new list<CartItem>();
//         set<id> productIds = new set<id>();
//          map<id,CartItem> itemlist1 = new map<id,CartItem>();
//         for(WebCart cart11 : cartid){
//         for(CartItem proid : cart11.CartItems){
//             productIds.add(proid.Product2Id);
//         }
//         }
//          list<PricebookEntry> pricsBookProduct= [SELECT Id, Name, Product2Id, UnitPrice, IsActive, CurrencyIsoCode FROM PricebookEntry where CurrencyIsoCode =:selectedCurrency And Product2Id IN:productIds];
//         for(WebCart cart2 : cartid){
//         //cart1.id=cartid.Id
//         //cart1.Status = 'Active';
//             cart2.CurrencyISOCode = selectedCurrency;
//             cart1.add(cart2);
//              for(CartItem item1:cart2.CartItems){
//                 for(PricebookEntry prices : pricsBookProduct ){
//                     if(item1.Product2Id == prices.Product2Id){
//                 cartItem cartItempro = new cartItem();
//                     cartItempro.id=item1.id;
//                     cartItempro.CurrencyIsoCode = prices.CurrencyIsoCode;
//                 cartItemPro.SalesPrice=prices.UnitPrice;
//                     cartItemPro.Sku =item1.Sku;
//                     cartItemPro.AdjustmentAmount = item1.AdjustmentAmount;
//                     cartItemPro.TotalPriceAfterAllAdjustments = prices.UnitPrice;
//                     cartItemPro.TotalLineAmount=prices.UnitPrice;
//                     cartItemPro.TotalListPrice=prices.UnitPrice;
//                     cartItemPro.TotalPrice=prices.UnitPrice;
//                     cartItemPro.UnitAdjustedPrice = prices.UnitPrice;
//                     //itemlist2.add(cartItemPro);
//                     itemlist1.put(item1.id,cartItemPro);

//                     }    
//             }
//                          }
//             update cart1;
//             update itemlist1.values();

        
        
           

// }*/
        
        
        
//         //@Author :[Harsha]
//         //
//         //
//        Map<Id, CartItem> productIdToCartItemMap = new Map<Id, CartItem>();
//         set<id> productIds = new set<id>();
//         map<id,CartItem> itemlist = new map<id,CartItem>();
//         list<WebCart> cartdetails =[select id,name,AccountId,CurrencyIsoCode,status,WebStoreId,OwnerId,
//                               (SELECT Id,Product2Id, 
//                                Name,Quantity, CurrencyISOCode,Sku, AdjustmentAmount, SalesPrice,TotalAmount, 
//                                TotalLineNetAmount, TotalLineGrossAmount, TotalPriceAfterAllAdjustments, 
//                                TotalLineAmount, TotalListPrice,TotalPrice, UnitAdjustedPrice FROM CartItems), 
//                                (SELECT CartId, CurrencyIsoCode, Name, Id FROM CartDeliveryGroups)  
//                               from WebCart where OwnerId =: userId and (Status = 'Active' or Status = 'Checkout' or Status ='Processing' or Status != 'Closed' or  Status != 'PendingDelete') ];
    
//         if(!cartdetails.isEmpty()){
//         system.debug('cartdetails'+cartdetails);
//         // list<WebCart> cartcurr= new list<WebCart>();
        
//         // cartdetails.CurrencyISOCode= 'CNY';
        
        
//         //update cartdetails;
//         list<WebCart> updatecart = new list<WebCart>();
//          for(WebCart cart1:cartdetails){
//                 //WebCart newcart = new WebCart();
//                 // newcart.id=cart1.id;
//              if(cart1.Status =='Active' || cart1.Status== 'Checkout' || cart1.Status=='Processing' ){ 
//                  cart1.CurrencyIsoCode =selectedCurrency;
//               updatecart.add(cart1);
                                        
//                 //cartcurr.add(newcart);
//            for(CartItem proid : cart1.CartItems){
//             productIds.add(proid.Product2Id);
//                productIdToCartItemMap.put(proid.Product2Id, proid);
//         }
//              }
//         }
//             update updatecart;
        
//         list<PricebookEntry> pricsBookProduct= [SELECT Id, Name, Product2Id, UnitPrice, IsActive, CurrencyIsoCode FROM PricebookEntry where CurrencyIsoCode =: selectedCurrency And Product2Id IN:productIds];
//         // map<id,CartItem> itemlist = new map<id,CartItem>();
//         // set<CartItem> itemlist2 = new set<CartItem>();
//         //list<CartItem> itemlist1 = new list<CartItem>();
        
//         for(PricebookEntry prices : pricsBookProduct){
//                if (productIdToCartItemMap.containsKey(prices.Product2Id)){
//                    CartItem originalCartItem = productIdToCartItemMap.get(prices.Product2Id);
//                    cartItem cartItempro = new cartItem();
//                    cartItempro.id=originalCartItem.id;
//                    cartItempro.CurrencyIsoCode = prices.CurrencyIsoCode;
//                    cartItemPro.SalesPrice=prices.UnitPrice;
//                    cartItemPro.Sku =originalCartItem.Sku;
//                    cartItemPro.AdjustmentAmount = originalCartItem.AdjustmentAmount;
//                    cartItemPro.TotalPriceAfterAllAdjustments = prices.UnitPrice * originalCartItem.Quantity;
//                    cartItemPro.TotalLineAmount = prices.UnitPrice * originalCartItem.Quantity;
//                    cartItemPro.TotalListPrice = prices.UnitPrice * originalCartItem.Quantity;
//                    cartItemPro.TotalPrice = prices.UnitPrice * originalCartItem.Quantity;
//                     cartItemPro.UnitAdjustedPrice = prices.UnitPrice;
//                     //itemlist2.add(cartItemPro);
//                     itemlist.put(originalCartItem.id,cartItemPro);
                      
//             }
//         }
        
//         //itemlist1.addAll(itemlist);
//         update itemlist.values();
//           /*  B2BDeliverySample b2bdelivery = new B2BDeliverySample();*/
//         }
//    /* list<CartCheckoutSession> checkoutcurrency =[SELECT Id, IsDeleted, Name, CurrencyIsoCode, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, WebCartId, State, NextState, IsProcessing, BackgroundOperationId, IsArchived, OrderId, IsError, OrderReferenceNumber,WebCart.CurrencyIsoCode FROM CartCheckoutSession where  CreatedById =: userid];

//     system.debug(checkoutcurrency);
//         list<CartCheckoutSession> updatecurrency = new list<CartCheckoutSession>();            
//         for(CartCheckoutSession checkoutcurrency1 : checkoutcurrency){
//             if(checkoutcurrency1.CurrencyIsoCode != checkoutcurrency1.WebCart.CurrencyIsoCode)
//               checkoutcurrency1.CurrencyIsoCode = checkoutcurrency1.WebCart.CurrencyIsoCode;
//                 updatecurrency.add(checkoutcurrency1);
//             }
//        system.debug(updatecurrency);
//         update updatecurrency;*/

//     }
        
        
// }



