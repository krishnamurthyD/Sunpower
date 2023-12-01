public class Calculation {

    @AuraEnabled
    public static integer performAction(Integer num1,Integer num2,String st)
    {
       
            if(st=='ADD')
            {
                return(num1+num2);
            }
            else if(st=='Substract')
            {
                return(num1-num2);
            }
            else if(st=='Multiply')
            {
                return(num1*num2);
            }
             else if(st=='Divide')
            {
                return(num1/num2);
            }
     
        return 0;
    }
}