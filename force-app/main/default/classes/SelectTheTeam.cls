public with sharing class SelectTheTeam {
   
    @AuraEnabled(cacheable=true)
    public static List<Team__c>  getTeams(){
        return [SELECT Id,Name,Team_Code__c,Owner__c,Picture__c FROM Team__c WITH SECURITY_ENFORCED];
     
    }
    @AuraEnabled
    public static Team__c getTeam(String id){
       return [Select Name,Owner__c,Picture__c from Team__c where Id =: id];
    }
}