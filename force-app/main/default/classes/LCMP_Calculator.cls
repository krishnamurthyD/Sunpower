public  class LCMP_Calculator {
    
         @AuraEnabled
        public static Integer doAddition(Integer num1 ,Integer num2){
  
            Calculator.CalculatorSoap c =new Calculator.CalculatorSoap();
            
              return c.Add(num1,num2);
           
          //Integer result=c.Multiply(2,3);
          // System.debug('Result Of Numbers= '+result);  
        }

    
}