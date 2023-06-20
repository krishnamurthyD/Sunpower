global inherited sharing class B2B2C_MySubscriptionsService implements IB2B2C_MySubscriptionsService{
    
    global static Object getMySubscriptionProducts() {
        B2B2C_MySubscriptionsModal response = new B2B2C_MySubscriptionsModal();
        List<B2B2C_Subscription__c> subscriptionProducts = new List<B2B2C_Subscription__c>();
        Map<String, String> productImageByProductIds = new Map<String, String>();
        subscriptionProducts = B2B2C_MySubscriptionsDAO.getMysubscriptionProducts();

        System.debug('[RB] - B2B2C_MyProductsService.getMysubscriptionProducts :: subscriptionProducts => ' + subscriptionProducts);
        Set<String> productIdSet = new Set<String>();

        for(B2B2C_Subscription__c sp: subscriptionProducts) {
            if(sp.B2B2C_Order_Product__c!=null) {
                productIdSet.add(sp.B2B2C_Order_Product__r.Product2Id);
            }
        }
             
        if(productIdSet.size()>0) {
            List<String> productIdList = new List<String>();
            productIdList.addAll(productIdSet);
            productImageByProductIds = B2CUtils.getProductImages(productIdList);
    	}
        
        response.isSuccess = true;
        response.message = 'My Subscription Products Fetched Successfully';
        List<B2B2C_MySubscriptionsModal.ProductInfomation> prodInfoList = new List<B2B2C_MySubscriptionsModal.ProductInfomation>();
        Integer i = 0;
        for(B2B2C_Subscription__c sp: subscriptionProducts) {
            B2B2C_MySubscriptionsModal.ProductInfomation prodInfo = populateProductInfo(sp);
            if(sp.B2B2C_Order_Product__c!=null && productImageByProductIds.containsKey(sp.B2B2C_Order_Product__r.Product2Id)) {
                prodInfo.productImageURL = productImageByProductIds.get(sp.B2B2C_Order_Product__r.Product2Id);
            }
            prodInfoList.add(prodInfo);
            Type t = Type.forName('B2B2C_Subscription__c');
            SObject subscriptionObj = (SObject)t.newInstance();
            response.cancellationReason = B2CUtils.getPickListValuesDynamically(subscriptionObj, 'B2B2C_Cancellation_Reason__c');
        }
        response.prodInfo = prodInfoList;
        System.debug('[RB] - B2B2C_MyProductsService.getMysubscriptionProducts :: response => ' + response);
        return response;
    }

    static B2B2C_MySubscriptionsModal.ProductInfomation populateProductInfo(B2B2C_Subscription__c sp) {
        B2B2C_MySubscriptionsModal.ProductInfomation prodInfo = new B2B2C_MySubscriptionsModal.ProductInfomation();
        prodInfo.subscriptionId = sp.Id;
        prodInfo.quantity = (Integer)sp.B2B2C_Quantity__c;
        prodInfo.subscriptionStartDate = sp.B2B2C_Start_Date__c.format();
        prodInfo.intervalTermUnit = sp.B2B2C_Interval_Term_Unit__c;
        prodInfo.intervalTerm = sp.B2B2C_Interval__c;
        prodInfo.numberOfDeliveries = sp.B2B2C_Number_of_deliveries__c;
        prodInfo.status = sp.B2B2C_Status__c;
        prodInfo.cancellationReason = sp.B2B2C_Cancellation_Reason__c;
        prodInfo.nextOrderDate = sp.B2B2C_Next_Delivery_Date__c.format();

        //Date nextOrderDate;
        if(prodInfo.status.toLowerCase()=='active') {
            //nextOrderDate = sp.B2B2C_Start_Date__c;
            prodInfo.frequency = 'Deliver ' + sp.B2B2C_Quantity__c + ' units every ' + sp.B2B2C_Interval__c + ' ' + sp.B2B2C_Interval_Term_Unit__c;
        } else {
            prodInfo.frequency = 'Delivered ' + sp.B2B2C_Quantity__c + ' units every ' + sp.B2B2C_Interval__c + ' ' + sp.B2B2C_Interval_Term_Unit__c;
        }
        /*Date subscriptionEndDate = sp.B2B2C_Start_Date__c;
        for(Integer i=1; i<sp.B2B2C_Number_of_deliveries__c; i++){
            if(sp.B2B2C_Interval_Term_Unit__c=='Day') {
                subscriptionEndDate = sp.B2B2C_Start_Date__c.addDays((Integer)sp.B2B2C_Interval__c);
            } else if(sp.B2B2C_Interval_Term_Unit__c=='Month') {
                subscriptionEndDate = sp.B2B2C_Start_Date__c.addMonths((Integer)sp.B2B2C_Interval__c);
            } else if(sp.B2B2C_Interval_Term_Unit__c=='Year') {
                subscriptionEndDate = sp.B2B2C_Start_Date__c.addYears((Integer)sp.B2B2C_Interval__c);
            }

            if(prodInfo.status.toLowerCase()=='active' && subscriptionEndDate>System.today() && nextOrderDate == sp.B2B2C_Start_Date__c) {
                nextOrderDate = subscriptionEndDate;
            } else if(prodInfo.status.toLowerCase()!='active' && subscriptionEndDate<System.today()) {
                nextOrderDate = subscriptionEndDate;
            }
        }
        prodInfo.subscriptionEndDate = subscriptionEndDate.format();
        prodInfo.nextOrderDate = nextOrderDate!=null? nextOrderDate.format(): '';*/
        
        prodInfo.showCancelSubsctionButton = true;
        prodInfo.showSubsctionSettingButton = true;

        if(sp.B2B2C_Status__c.toLowerCase()!='active') {
            prodInfo.showCancelSubsctionButton = false;
            prodInfo.showSubsctionSettingButton = false;
        }

        if(sp.B2B2C_Order_Product__c!=null) {
            prodInfo.productId = sp.B2B2C_Order_Product__r.Product2Id;
            prodInfo.productName = sp.B2B2C_Order_Product__r.Product2.Name;
            prodInfo.productCode = sp.B2B2C_Order_Product__r.Product2.ProductCode;
            prodInfo.productSKU = sp.B2B2C_Order_Product__r.Product2.StockKeepingUnit;
            prodInfo.productDescription = sp.B2B2C_Order_Product__r.Description;
            prodInfo.listPrice = sp.B2B2C_Order_Product__r.ListPrice;
            prodInfo.unitPrice = sp.B2B2C_Order_Product__r.UnitPrice;
        }
        return prodInfo;
    }

    global static Object updateSubscriptionInformation(Object requestData) {
        B2B2C_MySubscriptionsModal modal = new B2B2C_MySubscriptionsModal();
        modal = (B2B2C_MySubscriptionsModal)requestData;
        System.debug('[RB] - B2B2C_MyProductsService.updateSubscriptionInformation :: requestData => ' + requestData);
        B2B2C_Subscription__c sub = new B2B2C_Subscription__c(Id=modal.prodInfo[0].subscriptionId);
        try{
            if(modal.operationType=='Cancel') {
                sub.B2B2C_Status__c = 'Cancelled';
                sub.B2B2C_Cancellation_Reason__c = modal.prodInfo[0].cancellationReason;
            }
            if(modal.operationType=='Update') {
                sub.B2B2C_Quantity__c = modal.prodInfo[0].quantity;
                sub.B2B2C_Interval__c = modal.prodInfo[0].intervalTerm;
                sub.B2B2C_Interval_Term_Unit__c = modal.prodInfo[0].intervalTermUnit;
                sub.B2B2C_Next_Delivery_Date__c = Date.valueOf(modal.prodInfo[0].nextOrderDate);
            }
            B2B2C_MySubscriptionsDAO.updateRecords(new List<B2B2C_Subscription__c>{sub});
            modal = (B2B2C_MySubscriptionsModal)getMySubscriptionProducts();
            modal.isSuccess = true;
            modal.message = 'Subscription Updated Successfully';
        } catch(Exception e) {
            modal.isSuccess = false;
            modal.message = e.getMessage();
        }
        return modal;
    }

    public static List<B2B2C_SubscriptionOption> getSubscriptionOptions(String subscriptionProductId) {
        List<ProductAttribute> productAttributes = B2B2C_MySubscriptionsDAO.getProductAttributes(subscriptionProductId);
        
        List<B2B2C_SubscriptionOption> subscriptionOptions = new List<B2B2C_SubscriptionOption>();
        for(ProductAttribute productAttribute :productAttributes) {
            String metaDataStr = productAttribute.Product.B2B2C_Subscription_Metadata__c;
            B2B2C_SubscriptionOption subscriptionOption = new B2B2C_SubscriptionOption();
            subscriptionOption.id = productAttribute.ProductId;
            subscriptionOption.intervalLabel = productAttribute.Delivery_Interval__c;
            if(String.isNotBlank(metaDataStr)) {
                Map<String, Object> metaData = (Map<String, Object>)JSON.deserializeUntyped(metaDataStr);
                if(metaData.containsKey('isOneTimePurchase') && Boolean.valueOf(metaData.get('isOneTimePurchase')) == true){
                continue;
            } else if(metaData.containsKey('intervalTermUnit') && metaData.containsKey('intervalTerm')){
                subscriptionOption.intervalTermUnit = String.valueOf(metaData.get('intervalTermUnit'));
                subscriptionOption.intervalTerm = String.valueOf(metaData.get('intervalTerm'));
            }
            }
            subscriptionOptions.add(subscriptionOption);
        }
        return subscriptionOptions;
        //return DummyDataClass.getDummySubscriptionOption();
    }

     /**
    * @description : will genrate subscription record for subscription order
    * @param orderSummeries 
    **/
    public B2B2C_genricResponseModal insertSubscriptions(Set<Order> Orders){
        B2B2C_genricResponseModal resp = new B2B2C_genricResponseModal();
        resp.isSuccess = true;
        try{

            //Get cart session based on order 
            List<CartCheckoutSession>session =  getCartSession(Orders);

            //Extract OrderNumbers
            List<String> orderNumberList = B2CUtils.getFieldValuesList(new List<order>(orders),'OrderNumber');
            
            //Extract webcartIDs
            List<String> cartIDSet = B2CUtils.getFieldValuesList(session,'WebCartId');

            //Get Cart items
            List<CartItem> CartItems =  getCartItemwithCartId(cartIDSet);

            //filter based on long area field
            CartItems =  B2CUtils.filterNonNullValues(CartItems,'B2B2C_Subscription_Metadata__c');

            //create map of productID and B2B2C_Subscription_Metadata__c
            Map<String,String> cartItemMap =  B2CUtils.constructMap(CartItems,'Product2Id','B2B2C_Subscription_Metadata__c');


            //Get order item summeries 
            List<OrderItem> orderSummaryItem = getOrderItem(orders);

            //Get map of product and ordersuumay id
            Map<String,sobject> orderSummaryMap = B2CUtils.mapByFieldName(orderSummaryItem,'Product2Id');


            //get subscritions for order
            List<B2B2C_Subscription__c> subsList = getSubsctiption(orderSummaryMap, cartItemMap );
            system.debug('cartItemMap == '+ cartItemMap);

            insert subsList;
            
            return resp;

        } Catch(exception  e){
            //log exception
            resp.isSuccess = false;
            resp.message = e.getMessage() +e.getStackTraceString();
            System.debug('exception='+ e.getMessage() +e.getStackTraceString());
            return resp;
        }
    }

     /**TODO : MOVE TO DAO LAYER
    * @description get order summeries
    * @param orderSummeries 
    * @return List<OrderItemSummaries> 
    **/
    private List<OrderItem> getOrderItem(Set<Order> orders){
        return[
            Select Id,Product2Id,quantity from OrderItem where OrderId IN : orders
         ];
    }

     /**TODO : MOVE TO DAO LAYER
    * @description get cart items
    * @param CartIDs 
    * @return List<CartItem> 
    **/
    private List<CartItem> getCartItemwithCartId(List<String> CartIDs){
        return[
            SELECT Id, B2B2C_Subscription_Metadata__c,Product2Id  FROM cartItem WHERE  CartId IN : CartIDs
         ];
    }


     /**TODO : MOVE TO DAO LAYER
    * @description get cart sessiom
    * @return List<CartCheckoutSession> 
    **/
    private List<CartCheckoutSession> getCartSession(Set<Order> OrderIDs){
        return[
             SELECT Id, WebCartId
             FROM CartCheckoutSession
             WHERE OrderId IN :OrderIDs 
         ];
     }


        /**
    * @description : get list of subscription items
    * @param orderSummaryMap 
    * @param cartItemMap 
    * @return List<B2B2C_Subscription__c> 
    **/
    private List<B2B2C_Subscription__c> getSubsctiption(Map<String,sobject> orderSummaryMap , Map<String,String> cartItemMap){
        List <B2B2C_Subscription__c> retunList = new List <B2B2C_Subscription__c>();
        for(Id item : cartItemMap.keySet()){
            Map<String,Object> cartMap =  (Map<String, Object>)JSON.deserializeUntyped(cartItemMap.get(item));
            orderItem ordItem  =  (orderItem) orderSummaryMap.get(item);
            // according to map valuus prepare list <subscriptions?
            B2B2C_Subscription__c sub = new B2B2C_Subscription__c();
            sub.B2B2C_Interval__c =Double.valueOf(cartMap.get('intervalTerm'));
            sub.B2B2C_Interval_Term_Unit__c = (String) cartMap.get('intervalTermUnit');
            sub.B2B2C_Number_of_deliveries__c = Double.valueOf(cartMap.get('numberOfDeliveries'));
            sub.B2B2C_Quantity__c = ordItem?.quantity;
            sub.B2B2C_Start_Date__c	= system.Today() ;
            sub.B2B2C_Next_Delivery_Date__c = system.Today().addMonths(Integer.valueOf(cartMap.get('intervalTerm'))) ;
            sub.B2B2C_Order_Product__c =ordItem?.Id;
            retunList.add(sub);
        }
        return retunList;
    }
}