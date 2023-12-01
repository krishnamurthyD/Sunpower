public with sharing class getDateFromOuterWebSite {
    @AuraEnabled
    public static Map<string, Object> getYotPodata(){
        Map<String, Object> newsJsonData = new Map<String, Object>();
        string strResponse =null;
        try {
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('https://api.yotpo.com/v1/apps/2mlFpC0XOOr1a11WRVpxqDrb7x6qFDVwPRLnOuNr/reviews?utoken=GiSSAzk7S1Rgl2XStdgdYoWuOXd0FbSt1K2xYXCC');
            request.setMethod('GET');
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('accept', 'application/json');
            HttpResponse response = http.send(request);
            if(response.getStatusCode() == 200){
                strResponse = response.getBody();
                system.debug(strResponse);
            } else {
                throw new CalloutException(response.getBody());
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        if(!String.isBlank(strResponse)){
            newsJsonData = (Map<String, Object>)JSON.deserializeUntyped(strResponse);
        }
        if(!newsJsonData.isEmpty()){
            return newsJsonData;
            
        } else {
            return null;
        }
    }
      
    
}