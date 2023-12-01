public class ScheduleApex implements Schedulable {
    public void execute(SchedulableContext sc){
        List<Opportunity> oppList=[SELECT id,Name,OwnerID 
                               FROM opportunity 
                               where Isclosed=false and closeDate<Today 
                              ];
        
        taskOwners.RemindOwner(oppList);
    }

}