public class ExceptionHandlingExample1 {
    public static void MyMethods(){
        system.debug('I am 1');
        try{
            integer a=6;
        integer b=a*5;
            system.debug('I am 2');
            
        }
        catch(exception e){
            System.debug('Exception Occured'+e.getMessage());
            System.debug('I am 3');
        }
        finally{
            System.debug('I will execute irrespective of exception occurs or not 4');
        }
        System.debug('I am 5');
        
    }

}