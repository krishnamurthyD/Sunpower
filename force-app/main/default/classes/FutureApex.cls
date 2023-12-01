public class FutureApex {
@future
public static void CountOfContacts(List<Id> recordIds)
{
    List<Account> accList=[SELECT Id,(SELECT Id FROM Contacts) FROM Account WHERE Id IN: recordIds];
    for(Account acc:accList)
    {
        acc.Number_of_Contacts__c=acc.Contacts.size();
        
    }
    update accList;
}
}