public class restApi {
    public static void restCall(){
        List<onerestWrapper> summary = new list<onerestWrapper>();
        string endpoint ='https://wikimedia.org/api/rest_v1/metrics/pageviews/per-article/en.wikipedia/all-access/all-agents/Albert_Einstein/daily/2015100100/2015103100';
        http h1 = new Http();
        httpRequest req1 = new httpRequest();
        req1.setHeader('content-Type','application/json');
        req1.setMethod('GET');
        req1.setEndpoint(endpoint);
        HttpResponse hresp = h1.send(req1);
        system.debug('***response'+hresp.getBody());
        JSONParser parser = JSON.createParser(hresp.getBody());
        While(parser.nextToken()!=null){
            if(parser.getCurrentToken()== JSONTOKEN.START_ARRAY){
                while(parser.nextToken()!=null){
                    if(parser.getCurrentToken()== JSONTOKEN.START_OBJECT){
                        onerestWrapper wrap = (onerestWrapper)parser.readValueAs(onerestWrapper.class);
                        if(string.isNotBlank(wrap.project)){
                           summary.add(wrap);
                        }
                    }
                    //system.debug('summry-->'+summary);
                }
            }  
        }
        if(summary.size()>0){
          string proj;
          string tme;
           string views;
            for(onerestWrapper eachItem:summary){
               proj =  eachItem.project;
                system.debug('project'+proj);
            }
        }
    }
}