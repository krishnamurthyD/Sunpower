public class MergingRecords
{
       public void MergingMethod()
       {
           Account masterAcc=[SELECT Id,Name,Phone FROM Account Where Name='krishna5'];
           Account mergeAcc=[SELECT Id,Name,Phone FROM Account Where Name='test School 1'];
           
           merge masterAcc mergeAcc;
       }
    //un delete
    // List<Account> deletedAcc=[SELECT Id,Name,Phone FROM Account 
    //  Where Name='krishna5' ALL ROWS];     
     //UNdelete deletedAcc;

}