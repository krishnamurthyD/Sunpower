@isTest
public class FutureTesting {
@isTest
    public static void testFuture()
    {
        List<Account> accList=new List<Account>();
        
        for(integer i=0;i<5;i++)
        {
            Account acc=new Account(Name='Test'+i);
            accList.add(acc);
        }
        insert accList;
        List<Contact> conList=new List<Contact>();
        List<Id> accIds=new List<Id>();
        for(Account acc:accList)
        {
            accIds.add(acc.Id);
            for(Integer i=0;i<1;i++)
            {
                Contact con=new Contact();
                con.LastName='testContact'+i;
                con.AccountId=acc.Id;
                conList.add(con);
            }
        }
        insert conList;
        
        Test.startTest();
        FutureApex.CountOfContacts(accIds);
        Test.stopTest();
        
        List<Account> accList1=[Select Id,Number_of_Contacts__c FROM Account WHERE Id IN: accIds];
        System.assertequals(1,accList1[0].Number_of_Contacts__c);
    }
}