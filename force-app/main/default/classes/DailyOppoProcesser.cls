public class DailyOppoProcesser implements Schedulable{
    public void execute(SchedulableContext sc){
        List<Opportunity> oppList=[SELECT id,Leadsource 
                                   FROM opportunity 
                                   WHERE leadsource=null Limit 200
                                  ];
        for(opportunity opp:oppList){
            opp.LeadSource='Web';
        }
        if(!oppList.isEmpty()){
            update oppList;
        }
    }

}