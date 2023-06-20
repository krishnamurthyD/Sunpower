public with sharing class B2B2C_MySubscriptionsModal {
    
    @AuraEnabled
    public Boolean isSuccess;
    @AuraEnabled
    public String message;
    @AuraEnabled
    public String operationType {get; set;}
    @AuraEnabled
    public List<ProductInfomation> prodInfo {get; set;}
    @AuraEnabled
    public List<B2CUtils.PicklistValueWrapper> cancellationReason;
 
    public class ProductInfomation {
        @AuraEnabled
        public String productId;
        @AuraEnabled
        public String productName;
        @AuraEnabled
        public String productCode;
        @AuraEnabled
        public String productSKU;
        @AuraEnabled
        public String productDescription;
        @AuraEnabled
        public String productImageURL;
        @AuraEnabled
        public Integer quantity {get; set;}
        @AuraEnabled
        public Decimal listPrice;
        @AuraEnabled
        public Decimal unitPrice;
        @AuraEnabled
        public String subscriptionId {get; set;}
        @AuraEnabled
        public String subscriptionStartDate;
        @AuraEnabled
        public String subscriptionEndDate;
        @AuraEnabled
        public String nextOrderDate {get; set;}
        @AuraEnabled
        public String frequency;
        @AuraEnabled
        public String intervalTermUnit {get; set;}
        @AuraEnabled
        public Decimal intervalTerm {get; set;}
        @AuraEnabled
        public Decimal numberOfDeliveries {get; set;}
        @AuraEnabled
        public String status {get; set;}
        @AuraEnabled
        public String cancellationReason {get; set;}
        @AuraEnabled
        public Boolean showCancelSubsctionButton;
        @AuraEnabled
        public Boolean showSubsctionSettingButton;
    }
}