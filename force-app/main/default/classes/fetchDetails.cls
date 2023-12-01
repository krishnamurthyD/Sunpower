public with sharing class fetchDetails{
    @AuraEnabled(cacheable=true)
    public static List<Opportunity> getdetails(string str){
        string sp='%'+str+'%';
        List<Opportunity> opp=new List<Opportunity>();
        opp=[select id ,Name from Opportunity where Name LIKE:sp];
        return opp;
    }
}