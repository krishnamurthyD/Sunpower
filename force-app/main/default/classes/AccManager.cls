@RestResource(urlMapping='/AccountManager/*')
//Inbound Integration some other app talking to salesforceApp
global class AccManager {
    @httpGet
    global static Account doGetMethod(){
        Account acc = new Account();
        Map<string,string> paramMap = RestContext.request.params;
        String accId = paramMap.get('id');
        acc = [select id, name from account where id =:accId];
        return acc;
    }
    @httpDelete
    global static String doDeleteMethod(){
        Account acc = new Account();
        Map<string,string> paramMap = RestContext.request.params;
        String accId = paramMap.get('id');
        acc = [select id, name from account where id =:accId];
        delete acc;
        return 'Account deleted Successfully!!';
    }

}