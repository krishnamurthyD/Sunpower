@isTest
public class DailyOppoProcesserTest {
    @isTest
    public static void testScheduleApex(){
        List<opportunity> oppList= new List<opportunity>();
        string scr='0 0 0 ? * * *';
    
    for(integer i=0; i<500; i++){
        if(i<250){
        oppList.add(new opportunity(name='Test'+i, StageName='prospecting', closeDate=system.today()));
        }else{
            oppList.add(new opportunity(name='Test'+i, StageName='prospecting', closeDate=system.today(), leadSource='others'));
        }
    }
    insert oppList;
        
        test.startTest();
        string jobId = System.schedule('OpportunityList' ,scr, new DailyOppoProcesser());
        test.stopTest();
        list<opportunity> updateOppList=[SELECT Id,LeadSource From opportunity where leadSource='Web'];
        system.assertEquals(200, updateOpplist.size());
    }
}