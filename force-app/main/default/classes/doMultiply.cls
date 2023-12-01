public class doMultiply {
    @AuraEnabled
        public static Integer doMultiply(Integer num1 ,Integer num2){
  
            Calculator.CalculatorSoap c =new Calculator.CalculatorSoap();
            
              return c.Multiply(num1,num2);
}
}