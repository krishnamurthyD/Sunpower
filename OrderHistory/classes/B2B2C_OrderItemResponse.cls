global with sharing class B2B2C_OrderItemResponse {
    @AuraEnabled
    public String orderItemId;
    @AuraEnabled
    public String product2Id;
    @AuraEnabled
    public String orderId;
    @AuraEnabled
    public Decimal quantity;
    @AuraEnabled
    public Decimal unitPrice;
    @AuraEnabled
    public Decimal listPrice;
    @AuraEnabled
    public Decimal totalPrice;
    @AuraEnabled
    public String message;
    @AuraEnabled
    public String productImageURL;
    @AuraEnabled
    public String productURL;
    @AuraEnabled
    public String productSKU;
    @AuraEnabled
    public String productName;
    @AuraEnabled
    public Boolean hasRelatedProducts;
    
}