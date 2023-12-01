global class multiply {
    public static Integer multiply(Integer num1,Integer num2) {
        Calculator.CalculatorSoap c =new Calculator.CalculatorSoap();
            
            return c.Multiply(num1,num2);

    }
}