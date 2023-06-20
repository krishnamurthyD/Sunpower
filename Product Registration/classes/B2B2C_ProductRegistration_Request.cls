public with sharing class B2B2C_ProductRegistration_Request {
    @AuraEnabled
    public String serialNumber {get; set;}
    @AuraEnabled
    public String productCode {get; set;}
    @AuraEnabled
    public Date purchaseDate {get; set;}
    @AuraEnabled
    public Integer pastDateMargin {get; set;}
    @AuraEnabled
    public Decimal purchasedPrice {get; set;}
}