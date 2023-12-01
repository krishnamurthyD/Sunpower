//Inbound Example
@RestResource(urlMapping='/Candidate/*')
global  class restExampleThroughPostman {
    @HttpGet
    global static Candidate__c demo()
    {
        String CandidateId;
        RestRequest request = RestContext.request;
        // grab the candidateId from the end of the URL
         CandidateId = request.requestURI.substring(
            request.requestURI.lastIndexOf('/')+1);
      Candidate__c  can =[ SELECT id,First_Name__c,Education__c,Currently_Employed__c
        FROM Candidate__c
        WHERE id= :CandidateId];
        
        return can;
    }
    
     @HttpPost
    global static id demoPost(String email ,String firstName,String education ,Boolean currentEmploye )
    {
      
        Candidate__c can =new Candidate__c();
        can.Email__c=email;
        can.First_Name__c=firstName;
        can.Education__c=education;
        can.Currently_Employed__c=currentEmploye;
         
        insert can;
        return Can.id;
        
        
    }
    
      @HttpPatch
    global static id demoPatch(String email ,String firstName,String education ,Boolean currentEmploye )
    {
       
         String CandidateId;
        RestRequest request = RestContext.request;
        // grab the candidateId from the end of the URL
         CandidateId = request.requestURI.substring(
            request.requestURI.lastIndexOf('/')+1);
        
       
        Candidate__c can =new Candidate__c();
        can.Id=CandidateId;
        can.Email__c=email;
        can.First_Name__c=firstName;
        can.Education__c=education;
        can.Currently_Employed__c=currentEmploye;
         
        update can;
        return can.id;
               
    }
    
      @HttpDelete
    global static string demoPatch()
    {
        string msg ='Succesfully deleted';
           String CandidateId;
        RestRequest request = RestContext.request;
        // grab the candidateId from the end of the URL
         CandidateId = request.requestURI.substring(
            request.requestURI.lastIndexOf('/')+1);
         
          Candidate__c can =new Candidate__c();
        can.Id=CandidateId;
        
        delete can;
        return msg;
        
    }
    
  
// put method
    @HTTPPut
    global static id demoPut(String email ,String firstName,String education ,Boolean currentEmploye) {
            String CandidateId;
        RestRequest request = RestContext.request;
        // grab the candidateId from the end of the URL
         CandidateId = request.requestURI.substring(
            request.requestURI.lastIndexOf('/')+1);
      
          
         Candidate__c can =new Candidate__c();
        can.Id=CandidateId;
        can.Email__c=email;
        can.First_Name__c=firstName;
        can.Education__c=education;
        can.Currently_Employed__c=currentEmploye;
        // Upserting 
        upsert can;
        // Returning the response
        return can.id;
    }
}