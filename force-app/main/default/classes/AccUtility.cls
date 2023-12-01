public class AccUtility {
    public static void mainMethod(){
        try{
        insertAccount();
        }
        catch(AccountException ae){
            system.debug('Message::::'+ae.getMessage());
            system.debug('Message:::::'+ae.getCause());
            system.debug('Line Number::'+ae.getLineNumber());
        }
        
    }
    public static void insertAccount(){
        try{
        Account acc=new Account();
        insert acc;
        }
        catch(DMLException dme){
            throw new AccountException('Account can not be created because the required feld name is missing',dme);
        }
    }

}