//Important Methodsfor Project  90% requirement For project outBound

public class restExample {

     public static void deleteUsers(){
       /* UserWrapper obj = new UserWrapper();
         obj.name='kumar';
         obj.email='Krishnamurthy45545@gmail.com';
         obj.status='active';
         obj.gender='male';*/
        // convertin Object into string
        // string str=json.serialize(obj);
         
         Http http = new Http();
        HttpRequest request = new HttpRequest();
       request.setEndpoint('https://gorest.co.in/public/v2/users/3839');
        request.setMethod('DELETE');
         
      //  request.setBody(str);  
      //Id is not Required
       //  request.setBody('{"name":"KrishnaSomayaji","email":"somayaji_jagadish@williamson.name","gender":"male","status":"active"}');
         request.setHeader('Content-Type','application/json');
         request.setHeader('Authorization', 'Bearer 0c61c417a8a4d9d89ed03f8a40889d291c6d30781324d1913278713527192d0c');
         HttpResponse response = http.send(request);
    
          if(response.getStatusCode() == 200) {
            System.debug('Status code' + response.getStatusCode());
            System.debug('body' + response.getBody());
              
          }
         
           else {
            System.debug('Status code' + response.getStatusCode());
            System.debug('body' + response.getBody());
        }
     }
     
     public static void putUsers(){
        UserWrapper obj = new UserWrapper();
         obj.name='kumar';
         obj.email='Krishnamurthy45545@gmail.com';
         obj.status='active';
         obj.gender='male';
        // convertin Object into string
         string str=json.serialize(obj);
         
         Http http = new Http();
        HttpRequest request = new HttpRequest();
       request.setEndpoint('https://gorest.co.in/public/v2/users/3839');
        request.setMethod('PUT');
         
        request.setBody(str);  
      //Id is not Required
       //  request.setBody('{"name":"KrishnaSomayaji","email":"somayaji_jagadish@williamson.name","gender":"male","status":"active"}');
         request.setHeader('Content-Type','application/json');
         request.setHeader('Authorization', 'Bearer 0c61c417a8a4d9d89ed03f8a40889d291c6d30781324d1913278713527192d0c');
         HttpResponse response = http.send(request);
    
          if(response.getStatusCode() == 200) {
            System.debug('Status code' + response.getStatusCode());
            System.debug('body' + response.getBody());
              
          }
         
           else {
            System.debug('Status code' + response.getStatusCode());
            System.debug('body' + response.getBody());
        }
     }
    
     public static void postUsers(){
         UserWrapper obj = new UserWrapper();
         obj.name='kumar';
         obj.email='Krishnamurthy@gmail.com';
         obj.status='active';
         obj.gender='male';
         string str=json.serialize(obj);
         
         Http http = new Http();
        HttpRequest request = new HttpRequest();
       request.setEndpoint('https://gorest.co.in/public/v2/users');
        request.setMethod('POST');
         
         request.setBody(str);
        // request.setBody('{"name":"Ramakrishna", "gender":"male", "email":"krishnamurthydonta@gmail.com", "status":"active"}');
         request.setHeader('Content-Type','application/json');
         request.setHeader('Authorization', 'Bearer 0c61c417a8a4d9d89ed03f8a40889d291c6d30781324d1913278713527192d0c');
         HttpResponse response = http.send(request);
         
         
         
          if(response.getStatusCode() == 200) {
            System.debug('Status code' + response.getStatusCode());
            System.debug('body' + response.getBody());
              
          }
         
           else {
            System.debug('Status code' + response.getStatusCode());
            System.debug('body' + response.getBody());
        }
     }
    
     public static void getUsers(){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
       request.setEndpoint('https://gorest.co.in/public/v2/users');
        request.setMethod('GET');
          HttpResponse response = http.send(request);
        // If the request is successful, parse the JSON response.
          if(response.getStatusCode() == 200) {
               System.debug('body' + response.getBody());
        // System.debug('response'+ response);
        List<UserWrapper> results = (List<UserWrapper>)JSON.deserialize(response.getBody(), List<UserWrapper>.class);
            
              for(Integer i=0 ; i<= 19 ; i++)  {
              System.debug('id: '+ results[i].id);
              System.debug('id: '+ results[i].gender);
              System.debug('id: '+ results[i].name);
              System.debug('id: '+ results[i].status);
                  System.debug('id: '+ results[i].email);
              }
              
           
    }
        else {
            System.debug('Status code' + response.getStatusCode());
            System.debug('body' + response.getBody());
        }
 }
    
     public class UserWrapper{
		public String email{get;set;}
		public String gender{get;set;}
		public String name{get;set;}
		public String status{get;set;}
		public Integer id{get;set;}
}
}