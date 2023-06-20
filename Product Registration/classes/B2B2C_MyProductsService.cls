global class B2B2C_MyProductsService implements IB2B2C_MyProductsService {
    private static final String CMS_URL_CONTAINS = '/cms/';

    global static Object getMyRegisteredProducts(String contactId){
        B2B2C_MyProductsResponse response = new B2B2C_MyProductsResponse();
        List<B2B2C_Registered_Product__c> registeredProducts = new List<B2B2C_Registered_Product__c>();
        registeredProducts = B2B2C_MyProductsDAO.getMyRegisteredProducts(contactId);

        System.debug('[RB] - B2B2C_MyProductsService.getMyRegisteredProducts :: registeredProducts => ' + registeredProducts);
        Set<String> productIdSet = new Set<String>();
        for(B2B2C_Registered_Product__c rp: registeredProducts) {
            productIdSet.add(rp.Product__c);
        }
        
        //Below map holds the sub-products. Here we are using it for warranty product
        Map<Id, Product2> productMap = new Map<Id, Product2>(B2B2C_MyProductsDAO.getProducts(productIdSet));
        
        List<String> productIdList = new List<String>();
        productIdList.addAll(productIdSet);
        Map<String, String> productImageByProductIds = B2CUtils.getProductImages(productIdList);

        response.isSuccess = true;
        response.message = 'My Registered Products Fetched Successfully';
        response.buyerId = contactId;
        List<B2B2C_MyProductsResponse.ProductInfomation> prodInfoList = new List<B2B2C_MyProductsResponse.ProductInfomation>();
        for(B2B2C_Registered_Product__c rp: registeredProducts) {
            B2B2C_MyProductsResponse.ProductInfomation prodInfo = populateProductInfo(rp, productMap);
            if(productImageByProductIds.containsKey(rp.Product__c)) {
                prodInfo.productImageURL = productImageByProductIds.get(rp.Product__c);
            }
            prodInfoList.add(prodInfo);
        }
        response.prodInfo = prodInfoList;
        System.debug('[RB] - B2B2C_MyProductsService.getMyRegisteredProducts :: response => ' + response);
        return response;
    }

    static B2B2C_MyProductsResponse.ProductInfomation populateProductInfo(B2B2C_Registered_Product__c rp, Map<Id, Product2> productMap) {
        B2B2C_MyProductsResponse.ProductInfomation prodInfo = new B2B2C_MyProductsResponse.ProductInfomation();
        prodInfo.productId = rp.Product__c;
        prodInfo.productName = rp.Product__r.Name;
        prodInfo.productCode = rp.Product_Code__c;
        prodInfo.productSKU = rp.Product_Code__c;
        prodInfo.productSerialNumber = rp.Serial_Number__c;
        prodInfo.purchaseAmount = rp.Purchase_Price__c;
        prodInfo.purchaseDate = rp.Purchase_Date__c.format();
        prodInfo.registeredDate = rp.Registered_Date__c.format();
        prodInfo.invoiceNumber = rp.Invoice_Number__c;
        prodInfo.isEligibleForWarranty = false;
        prodInfo.showPartsAndAccessoriesButton = false;

        if(String.IsNotBlank(rp.Product__r.b2b2c_RelatedProductCodes__c)){
            prodInfo.showPartsAndAccessoriesButton = true;
        }

        String productWarranty = rp.Product__r.b2b2c_Product_Warranty__c;
        if(String.IsBlank(productWarranty) || (String.IsNotBlank(productWarranty) && productWarranty=='-1')) {
            prodInfo.warrantyEndDate = 'No warranties available';
        }
        if(String.IsNotBlank(productWarranty) && productWarranty=='0' && rp.Product__r.b2b2c_Eligible_for_Warranty__c) {
            prodInfo.isEligibleForWarranty = true;
            prodInfo.warrantyEndDate = 'None';
            prodInfo.warrantyButtonLabel = 'Purchase Warranty';
        }
        if(String.IsNotBlank(productWarranty) && productWarranty!='-1' && productWarranty!='0') {
            Integer unitDays = productWarranty.toLowerCase().indexOf('day')!=-1? Integer.valueOf(productWarranty.substring(0, productWarranty.toLowerCase().indexOf('day')).trim()): 0;
            Integer unitMonths = productWarranty.toLowerCase().indexOf('month')!=-1? Integer.valueOf(productWarranty.substring(0, productWarranty.toLowerCase().indexOf('month')).trim()): 0;
            Integer unitYears = productWarranty.toLowerCase().indexOf('year')!=-1? Integer.valueOf(productWarranty.substring(0, productWarranty.toLowerCase().indexOf('year')).trim()): 0;
            Date warrantyExpiryDate = rp.Purchase_Date__c.addDays(unitDays).addMonths(unitMonths).addYears(unitYears);
            prodInfo.warrantyEndDate = warrantyExpiryDate.format();
        }
        if(productMap.containsKey(rp.Product__c) && productMap.get(rp.Product__c).Products__r.size()>0){
            prodInfo.warrantyProductId = productMap.get(rp.Product__c).Products__r[0].Id;
            prodInfo = populateWarrantyInfo(rp, prodInfo);
        } else {
            prodInfo.isEligibleForWarranty = false;
        }
        return prodInfo;
    }
    
    static B2B2C_MyProductsResponse.ProductInfomation populateWarrantyInfo(B2B2C_Registered_Product__c rp, B2B2C_MyProductsResponse.ProductInfomation prodInfo) {
        String productWarranty = rp.Product__r.b2b2c_Product_Warranty__c;
        
        if(String.IsNotBlank(productWarranty) && productWarranty!='-1' && productWarranty!='0') {
            Integer year = Integer.valueOf(prodInfo.warrantyEndDate.split('/')[2]);
            Integer month = Integer.valueOf(prodInfo.warrantyEndDate.split('/')[1]);
            Integer day = Integer.valueOf(prodInfo.warrantyEndDate.split('/')[0]);
            Date warrantyExpiryDate = Date.newInstance(year, month, day);
            if(rp.Product__r.b2b2c_Eligible_for_Warranty__c) {
                prodInfo.isEligibleForWarranty = true;
            }
            prodInfo.warrantyButtonLabel = 'Extend Warranty';
            prodInfo.isWarrantyExtendableAfterExp = true;
            if(warrantyExpiryDate<System.today()) {
                prodInfo.isWarrantyExpired = true;
                if(!rp.Product__r.b2b2c_Allow_Warranty_Extension_After_Exp__c) {
                    prodInfo.isEligibleForWarranty = false;
                    prodInfo.isWarrantyExtendableAfterExp = false;
                }
            }
        }
        return prodInfo;
    }
}