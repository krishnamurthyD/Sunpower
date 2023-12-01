public with sharing class IplServices {
    @AuraEnabled(cacheable=true)
    public static List<Team__c> getTeams(){
        return [Select Id,Name,Team_Code__c from Team__c WITH SECURITY_ENFORCED];
    }

    @AuraEnabled(cacheable=true)
    public static Team__c getATeam(String id){
        return [Select Name,Owner__c,Picture__c from Team__c where Id =: id WITH SECURITY_ENFORCED];
    }

    @AuraEnabled(cacheable=true)
    public static List<Match_Fixture__c> getMatches(String team1, String team2){
        if(team1 == '' && team2 == ''){
            return [Select Match_No__c,Day__c,Date__c,Match__c,Venue__c from Match_Fixture__c WITH SECURITY_ENFORCED ORDER BY Match_No__c ASC ];
        } else if(team1 == ''){
            String key = '%'+team2+'%';
            return [Select Match_No__c,Day__c,Date__c,Match__c,Venue__c from Match_Fixture__c where Match__c LIKE :key WITH SECURITY_ENFORCED ORDER BY Match_No__c ASC];
        } else if(team2 == ''){
            String key = '%'+team1+'%';
            return [Select Match_No__c,Day__c,Date__c,Match__c,Venue__c from Match_Fixture__c where Match__c LIKE :key WITH SECURITY_ENFORCED ORDER BY Match_No__c ASC];
        } else {
            String key1 = '%'+team1+'%';
            String key2 = '%'+team2+'%';
            return [Select Match_No__c,Day__c,Date__c,Match__c,Venue__c from Match_Fixture__c where Match__c LIKE :key1 AND Match__c LIKE :key2 WITH SECURITY_ENFORCED ORDER BY Match_No__c ASC];
        }
        
    }

    @AuraEnabled(cacheable=true)
    public static List<Map<String,String>> getNews(){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://newsapi.org/v2/top-headlines?country=in&category=sports&q=IPL&apiKey=61d7e2964f36466f9ad78dcdca2a92d2');
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        List<Map<String,String>> result = new List<Map<String,String>>();
        if(response.getStatusCode() == 200){
            NewsWrapper responseWrapper = NewsWrapper.parse(response.getBody());
            for(Integer i=0;i<responseWrapper.articles.size();i++){
                result.add(new Map<String,String>{'title'=>responseWrapper.articles[i].title, 'image'=>responseWrapper.articles[i].urlToImage});
            }
        }
        return (result);
    }
    
}