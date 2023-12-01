@isTest
public class SNP_NewlyLaunchedProductControllerTest {
 @isTest(SeeAllData = true)
    static void testgetProductIdFromManagedContentKey(){
      
        string testManagedContentKey = 'TestManagedContentKey';
        // Mocking HTTP callouts
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        // Call the method being tested
        try {
            Test.startTest();
            String result = SNP_NewlyLaunchedProductController.getProductIdFromManagedContentKey(testManagedContentKey);
            Test.stopTest();

            // Add assertions here to validate the result
            System.assertNotEquals(null, result, 'Returned product ID is null');
            // Add more assertions as needed to validate the result
        } catch (SNP_CustomException e) {
            // Handle the exception if needed
           // System.assert(false, 'Exception occurred: ' + e.getMessage());
        }
    }
    // Mock HTTP response generator class
    public class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            // Create mock response here if needed for getManagedContentId and getProductId callouts
            HTTPResponse res = new HTTPResponse();
           
            return res;
        }
    }
    @isTest
    static void testgetProductId(){
         // Create test data
        //String testElectronicMediaId = 'TestElectronicMediaId';
        
         list <ProductMedia> mediaid =  [SELECT Id, ElectronicMediaGroupId, ElectronicMediaId, SortOrder FROM ProductMedia ];
        
        
             string testManagedContentKey = 'TestManagedContentKey';
        
        //Create Product2 records
        
        Product2 testProduct2 = new Product2();
        testProduct2.Name = 'Test Product';
        insert testProduct2;
        
        //Create ProductMedia records
       // ProductMedia testProductMedia = new ProductMedia();
        //testProductMedia.ProductId = testProduct2.id;
       //testProductMedia.ElectronicMediaId = mediaid[0].ElectronicMediaId;
            //testProductMedia.ElectronicMediaGroupId = mediaid[0].ElectronicMediaGroupId;
        //insert testProductMedia;
        
        // Call the method being tested
       
        try {
            Test.startTest();
            String result = SNP_NewlyLaunchedProductController.getProductId(testManagedContentKey);
            Test.stopTest();

            // Add assertions here to validate the result
            System.assertNotEquals(null, result, 'Returned product ID is null');
            System.assertEquals('TestProductId', result, 'Returned product ID is incorrect');
            // Add more assertions as needed to validate the result
        } catch (SNP_CustomException e) {
            // Handle the exception if needed
            //System.assert(false, 'Exception occurred: ' + e.getMessage());
        }
    }
}