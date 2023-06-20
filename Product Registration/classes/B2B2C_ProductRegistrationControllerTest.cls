@isTest
public class B2B2C_ProductRegistrationControllerTest {
    static String serviceClassName = 'B2B2C_ProductRegistrationService';

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
        
        B2B2C_TestFactory.createProducts();
    }
    
    @isTest
    static void validateSerialNumberTest(){
        List<User> storeUsers = [SELECT Id FROM User WHERE LastName='Test' AND Profile.Name=:B2B2C_TestFactory.SHOPPERPROFILE];
        System.runAs(storeUsers[0]) {
            String serialNumber = 'MOTO-9808-545-001';
            Test.startTest();
                Boolean response = B2B2C_ProductRegistrationController.validateSerialNumber(serialNumber, serviceClassName);
            Test.stopTest();
            System.assertEquals(true, response, 'Response should be true.');
        }
    }

    @isTest
    static void validateProductCodeTest(){
        List<User> storeUsers = [SELECT Id FROM User WHERE LastName='Test' AND Profile.Name=:B2B2C_TestFactory.SHOPPERPROFILE];
        System.runAs(storeUsers[0]) {
            String productCode = 'WallCharger65W';
            Test.startTest();
                Boolean response = B2B2C_ProductRegistrationController.validateProductCode(productCode, serviceClassName);
            Test.stopTest();
            System.assertEquals(true, response, 'Response should be true.');
        }
    }

    @isTest
    static void validatePurchaseDateTest(){
        List<User> storeUsers = [SELECT Id FROM User WHERE LastName='Test' AND Profile.Name=:B2B2C_TestFactory.SHOPPERPROFILE];
        System.runAs(storeUsers[0]) {
            Date purchaseDate = System.today();
            Integer pastDateMargin = 365;
            Test.startTest();
                Boolean response = B2B2C_ProductRegistrationController.validatePurchaseDate(purchaseDate, pastDateMargin, serviceClassName);
            Test.stopTest();
            System.assertEquals(true, response, 'Response should be true.');
        }
    }

    @isTest
    static void registerProductPositiveTest(){
        List<User> storeUsers = [SELECT Id FROM User WHERE LastName='Test' AND Profile.Name=:B2B2C_TestFactory.SHOPPERPROFILE];
        System.runAs(storeUsers[0]) {
            B2B2C_ProductRegistration_Request prodDate = new B2B2C_ProductRegistration_Request();
            prodDate.serialNumber = 'MOTO-9808-545-001';
            prodDate.productCode = 'WallCharger65W';
            prodDate.purchaseDate = System.today();
            prodDate.pastDateMargin = 365;
            prodDate.purchasedPrice = 30;
            Test.startTest();
                B2B2C_ProductRegistration_Response response = B2B2C_ProductRegistrationController.registerProduct(prodDate, serviceClassName);
            Test.stopTest();
            System.assertEquals(true, response.isSuccess, 'Product should get registered successfully.');
        }
    }

    @isTest
    static void registerProductNegativeTest(){
        B2B2C_ProductRegistration_Request prodDate = new B2B2C_ProductRegistration_Request();
        prodDate.serialNumber = 'MOTO-9808-545-001';
        prodDate.productCode = 'WallCharger65W';
        prodDate.purchaseDate = System.today();
        prodDate.pastDateMargin = 365;
        prodDate.purchasedPrice = 30;
        Test.startTest();
            B2B2C_ProductRegistration_Response response = B2B2C_ProductRegistrationController.registerProduct(prodDate, serviceClassName);
        Test.stopTest();
        System.assertEquals(false, response.isSuccess, 'Product should not get registered.');
    }
}