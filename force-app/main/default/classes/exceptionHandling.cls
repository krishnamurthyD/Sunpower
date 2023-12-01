public class exceptionHandling {
    public static void Mymethod(integer i){
        try{
            if(i==0){
            integer a;     //a=Null
            integer b=a*5;  //Throws Null point Exception-->(throw object of exception class)
            }
            else{
                Account acc =new Account();
                insert acc;   //Throws DML Exception--> (throw object of exception class)
            }
        }
        catch(NullPointerException npe){
             system.debug('I execute when Null Pointer Exception occur in the try block'+npe.getMessage());
        }
        catch(DMLException d){
            system.debug('I execute when DML Exception occur in the try block'+d.getMessage());
        }
        catch(Exception e){
            system.debug('I execute when there is any other exception expect DMLException occur'+e.getMessage());
        }
        finally{
            System.debug('I will Execute Irrespective of Exception Occur or not');
        }
    } 

}

//string str;
//boolean boool=str.contains("Krishna");  --> System.NullpointException
//system.debug(bool);