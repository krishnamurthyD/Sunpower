global with sharing class B2B2C_OrderResponse {
    @AuraEnabled
    public String orderNumber;
    @AuraEnabled
    public Decimal orderTotal;
    @AuraEnabled
    public String createdDate;
    @AuraEnabled
    public String status;
    @AuraEnabled
    public String orderId;
    @AuraEnabled
    public String message;
    @AuraEnabled
    public List<B2B2C_OrderItemResponse> orderItemList = new List<B2B2C_OrderItemResponse>();
    @AuraEnabled
    public Boolean isSuccess;
    @AuraEnabled
    public Decimal totalDeliveryAmount;
    @AuraEnabled
    public Decimal grandTotal;
    @AuraEnabled
    public Decimal totalTaxAmount;
    @AuraEnabled
    public String deliveryCity;
    @AuraEnabled
    public String deliveryState;
    @AuraEnabled
    public String deliveryPostalCode;
    @AuraEnabled
    public String deliveryStreet;
    @AuraEnabled
    public String deliveryCountry;
    @AuraEnabled
    public String deliveryMethod;
    @AuraEnabled
    public String deliveryStatus;
    @AuraEnabled
    public String orderSummaryId;
    @AuraEnabled
    public String webStoreId;
}