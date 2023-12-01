public with sharing class AccountServices {
@AuraEnabled
public static List<Account> getAccounts(String strAccountName) {
  String strKey = '%'+strAccountName+'%';
   List<Account> accList = [SELECT Id,Name,AccountNumber FROM Account WHERE name like :strKey ];
   return accList;
}
}