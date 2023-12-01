public class DemoList 
{
    public void demoMethod1()
    {
        List<Account> accList=new List<Account>();
        Set<Id> accIds=new Set<Id>();
        accList=[SELECT Id,Name FROM Account Limit 2];
        Map<Id,Account> idToAccountMap = new Map<Id,Account>(accList);
     
        
       if(!accList.isEmpty())  //check the list is empty.'set'
        {
         for(Account acc : accList)
          {
            accIds.add(acc.id);
          }
       }
       if(!accIds.isEmpty())
       {
           for(Id i : accIds)
               if(idToAccountMap.containsKey(i))
                {
               System.debug(' map value => ' +idToAccountMap.get(i));
                }
        // System.debug('i=>' +i);  
       }  
    }

}