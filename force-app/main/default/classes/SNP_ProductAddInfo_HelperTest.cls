@isTest
public class SNP_ProductAddInfo_HelperTest {
    @isTest(SeeAllData = true)
    static void testGetManagedContent() {
        // Create a test community
        
        id networkid=[SELECT Id, Name FROM Network where name ='PowerLEDQA'].id; 
        List<ManagedContent> ManagedContents =[SELECT Id FROM ManagedContent];
        
        list<string> ManagedContent1 = new list<string>();
         // Now, you can work with the queried records
        for (ManagedContent mc : ManagedContents) {
            // Convert the ManagedContent object to a String
            String mcString = mc.Id;
              ManagedContent1.add(mcString);
            // Perform your test logic here with the converted String
            System.debug('Managed Content as String: ' + mcString);
        }
        
       
        //Community testcommunity = new Community(Name='Internal Community');
        //insert testcommunity;

        // Retrieve the community's Id
        //testcommunity = [SELECT Id FROM Community WHERE Id = :testcommunity.Id];

        List<String> managedContentIds = new List<String>{'123', '456', '789'};

        // Call the method to be tested
        ConnectApi.ManagedContentVersionCollection result = SNP_ProductAddInfo_Helper.getManagedContent(networkid, ManagedContent1);

        // Verify that the method returns a non-null result
        System.assertNotEquals(null, result, 'ManagedContentVersionCollection should not be null');
    }
        
}