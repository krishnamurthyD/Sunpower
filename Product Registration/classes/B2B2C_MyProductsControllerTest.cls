@isTest
public class B2B2C_MyProductsControllerTest {
    static String serviceClassName = 'B2B2C_MyProductsService';

    @TestSetup
    static void makeData(){
        Profile b2cProfile = [SELECT Id, Name FROM Profile WHERE Name = :B2B2C_TestFactory.SHOPPERPROFILE];
        
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;

        Contact con = new Contact();
        con.FirstName = 'test2';
        con.LastName = 'contact2';
        con.Email = 'test2@test.com';
        con.AccountId = acc.Id;
        insert con; 

        String dateString = String.valueof(Datetime.now()).replace(' ', '').replace(':', '').replace('-', '');
        Integer RandomId = Integer.valueOf(Math.rint(Math.random() * 1000000));
        
        B2B2C_TestFactory.UserAttributes ua = new B2B2C_TestFactory.UserAttributes();
        ua.orgId = UserInfo.getOrganizationId();
        ua.uniqueName = ua.orgId + dateString + RandomId;
        ua.profileId = b2cProfile.Id;
        ua.contactId = con.Id;
        B2B2C_TestFactory.insertPortalUser(ua);
        
        List<Product2> productList = B2B2C_TestFactory.createProducts();

        List<B2B2C_Registered_Product__c> registeredProducts = new List<B2B2C_Registered_Product__c>();
        B2B2C_Registered_Product__c regProd1 = new B2B2C_Registered_Product__c();
        regProd1.Contact__c = con.Id;
        regProd1.Product__c = productList[0].Id;
        regProd1.Product_Code__c = productList[0].productCode;
        regProd1.Serial_Number__c = 'MOTO-9806-545-001';
        regProd1.Purchase_Date__c = System.today().addDays(-25);
        regProd1.Purchase_Price__c = 10;
        regProd1.Registered_Date__c = System.today();
        registeredProducts.add(regProd1);

        B2B2C_Registered_Product__c regProd2 = new B2B2C_Registered_Product__c();
        regProd2.Contact__c = con.Id;
        regProd2.Product__c = productList[1].Id;
        regProd2.Product_Code__c = productList[1].productCode;
        regProd2.Serial_Number__c = 'MOTO-9807-545-001';
        regProd2.Purchase_Date__c = System.today().addDays(-25);
        regProd2.Purchase_Price__c = 30;
        regProd2.Registered_Date__c = System.today();
        registeredProducts.add(regProd2);

        B2B2C_Registered_Product__c regProd3 = new B2B2C_Registered_Product__c();
        regProd3.Contact__c = con.Id;
        regProd3.Product__c = productList[2].Id;
        regProd3.Product_Code__c = productList[2].productCode;
        regProd3.Serial_Number__c = 'MOTO-9808-545-001';
        regProd3.Purchase_Date__c = System.today().addDays(-30);
        regProd3.Purchase_Price__c = 699;
        regProd3.Registered_Date__c = System.today();
        registeredProducts.add(regProd3);

        insert registeredProducts;
    }

    @isTest
    static void getMyRegisteredProductsTest(){
        List<User> storeUsers = [SELECT Id FROM User WHERE LastName='Test' AND Profile.Name=:B2B2C_TestFactory.SHOPPERPROFILE];
        System.runAs(storeUsers[0]) {
            Test.startTest();                
                B2B2C_MyProductsResponse response = B2B2C_MyProductsController.getMyRegisteredProducts(serviceClassName);
            Test.stopTest();
            System.assertEquals(true, response.isSuccess, 'It should return registered products successfully');
            System.assertEquals(3, response.prodInfo.size(), 'Registered products should be 3');
        }
    }

}