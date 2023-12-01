public class UpsertList
{
   public void upsertMethod()
   {
       List<Account> accList=new List<Account>();

Account acc1=new Account(Name='test School 1',Phone='1234567');
Account acc2=[SELECT Id,Name,Phone FROM Account Where Name='krishna5'];

acc2.phone='12121212';

accList.add(acc1);
accList.add(acc2);

Upsert accList;

   }

}