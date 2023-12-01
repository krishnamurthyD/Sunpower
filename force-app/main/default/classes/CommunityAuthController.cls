public without sharing class CommunityAuthController {
    public CommunityAuthController() {

    }

    @AuraEnabled
    public static string doLogin(String username, String password){
        try {
            
            String startUrl = System.Label.Community_Url;
            ApexPages.PageReference pageRef = Site.login(username, password, startUrl);
            system.debug('pageRef'+pageRef);

            if(pageRef != null) {
                return pageRef.getUrl();
            }
            throw new CalloutException();
          //  return null;


        } catch (Exception e) {
            system.debug('e.getMessagelogin+   '+e.getMessage());
            throw new AuraHandledException(e.getMessage());
         //   return null;
        }
       
  }
    @AuraEnabled
    public static boolean forgotPassword(String username){
        try {
           // boolean ispassword = Site.forgotPassword(username);
           // system.debug('ispassword'+ispassword);

            //if(ispassword==true) {
               // return ispassword;
            //}
            //throw new CalloutException();
          //  return null;
          //  
		 	list<user> users = Database.Query('SELECT Id, Name FROM User WHERE UserName  =: username');
 
            for(User u : users){
                //For reset User password
                System.resetPassword(u.Id, true);
            }

        } catch (Exception e) {
            system.debug('e.getMessagelogin+   '+e.getMessage());
            throw new AuraHandledException(e.getMessage());
         //   return null;
        }
        return null;
       
  }
    @AuraEnabled
    public static ConnectApi.ProductDetail Product(){
        
        try {  
		 	return ConnectApi.CommerceCatalog.getProduct('0ZE7Y0000000Da7WAE', '01t2X000006u9i5QAA', '0ZE7Y0000000Da7WAE', null, false, null, false, false, false);
        } catch (Exception e) {
            system.debug('e.getMessagelogin+   '+e.getMessage());
            throw new AuraHandledException(e.getMessage());
         //   return null;
        }
        
       
        
    }
    
}