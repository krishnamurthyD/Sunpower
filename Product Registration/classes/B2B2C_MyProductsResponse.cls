public with sharing class B2B2C_MyProductsResponse {
    @AuraEnabled
    public Boolean isSuccess;
    @AuraEnabled
    public String message;
    @AuraEnabled
    public String buyerId;
    @AuraEnabled
    public List<ProductInfomation> prodInfo = new List<ProductInfomation>();

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
        public String productSerialNumber;
        @AuraEnabled
        public String productModelNumber;
        @AuraEnabled
        public String productImageURL;
        @AuraEnabled
        public String invoiceNumber;
        @AuraEnabled
        public String purchaseDate;
        @AuraEnabled
        public Decimal purchaseAmount;
        @AuraEnabled
        public String registeredDate;
        @AuraEnabled
        public String warrantyPurchaseDate;
        @AuraEnabled
        public String warrantyEndDate;
        @AuraEnabled
        public Boolean isWarrantyExpired;
        @AuraEnabled
        public Boolean isEligibleForWarranty;       //Purchase Warranty
        @AuraEnabled
        public Boolean isWarrantyExtendable;        //Extend Warranty
        @AuraEnabled
        public Boolean isWarrantyExtendableAfterExp;    //Extend Warranty after Expiration
        @AuraEnabled
        public String warrantyButtonLabel;    //Extend Warranty after Expiration
        @AuraEnabled
        public Boolean showPartsAndAccessoriesButton;   //Parts and Accessories
        @AuraEnabled
        public String warrantyProductId;   //Warranty's product id
    }
}