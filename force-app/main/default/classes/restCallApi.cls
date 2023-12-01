public class restCallApi {
    public static void restCallApiTwo(){
    Http http =new Http();
    HttpRequest request = new HttpRequest();
    string endPoint ='https://th-apex-http-callout.herokuapp.com/animals';
    request.setEndpoint(endPoint);
    request.setMethod('GET');
    HttpResponse response=http.send(request);
        system.debug('Response->'+response.getbody());
        }
    public static void restCallApiThree(){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        string endPoint ='https://th-apex-http-callout.herokuapp.com/animals';
        request.setEndpoint(endPoint);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody('{"name":"Vinod"}');
        HttpResponse response=http.send(request);
        system.debug('Response->'+response.getbody());
    }
        
}