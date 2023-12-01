public class DemoSObjects
{
    public void demoMethod()
    { 
        sObject obj;
        
        //Standard sObject
      obj = new Account(Name='mantu',Phone='6964586496');//constructor 
      //acc.Name ='Krishna murthy';
      //acc.Phone ='8884769385';
      Account acc=(Account)obj;
      System.debug('acc=>' +acc);  
        
       obj =new Student__c(High_School_Phone__c=23423,Name='gopal');
        //std.High_School_Phone__c=23423;
        //std.Name='gopal';
        Student__c std=(Student__c)obj;
        System.debug('std=>' +std);
    }
}