global with sharing class B2B2C_OrderDetailService implements IB2B2C_OrderDetailService {

    global String getOrderDetail(String inputData){

        List<B2B2C_OrderResponse> responseList = new List<B2B2C_OrderResponse>();
        Map<String, Object> returnedData = new Map<String, Object>();
        Map<String, Object> requestData = (Map<String, Object>) JSON.deserializeUntyped(inputData);
        String orderId = (String)requestData.get('orderId');
        System.debug('orderId--->'+orderId);
        try{
            if(String.isNotBlank(orderId)){
                String queryString = ' Select Id,CreatedDate, OrderNumber,Status,TotalAmount from Order ';
                String  whereClause = ' where Id=: orderId ';
                String orderAndLimitString = ' ';
                
                String finalQuery = queryString + whereClause + orderAndLimitString;
                Order order  = (Order)Database.query(finalQuery);
                System.debug('orderList--->'+order);
                if(order != null){
                    List<OrderItem> orderItemList = [Select Id,Product2Id, Product2.b2b2c_RelatedProductCodes__c, Product2.Name,Product2.StockKeepingUnit, Quantity,TotalPrice,UnitPrice,ListPrice,OrderId from OrderItem where OrderId =: order.Id AND Type !=  'Delivery Charge'];

                    List<B2B2C_OrderItemResponse> orderItemResponseList = new List<B2B2C_OrderItemResponse>();
                    Set<String> productIdSet = new Set<String>();
                    for(OrderItem orderItem : orderItemList){
                        productIdSet.add(orderItem.Product2Id);
                    }
                    List<String> productIdList = new List<String>();
                    productIdList.addAll(productIdSet);
                    Map<String, String> productImageByProductIds = B2CUtils.getProductImages(productIdList);

                    for(OrderItem orderItem : orderItemList){
                        B2B2C_OrderItemResponse orderItemResponse = new B2B2C_OrderItemResponse();
                        orderItemResponse.listPrice = orderItem.ListPrice;
                        orderItemResponse.unitPrice = orderItem.UnitPrice;
                        orderItemResponse.product2Id = orderItem.Product2Id;
                        orderItemResponse.quantity = orderItem.Quantity;
                        orderItemResponse.orderId = orderItem.OrderId;
                        orderItemResponse.productSKU = orderItem.Product2.StockKeepingUnit;
                        orderItemResponse.orderItemId = orderItem.Id;
                        orderItemResponse.productName = orderItem.Product2.Name;
                        if(orderItem.Product2.b2b2c_RelatedProductCodes__c != null){
                            orderItemResponse.hasRelatedProducts = true;
                        }else{
                            orderItemResponse.hasRelatedProducts = false;
                        }
                        orderItemResponse.totalPrice = orderItem.TotalPrice;
                        if(productImageByProductIds.containsKey(orderItem.Product2Id)) {
                            orderItemResponse.productImageURL = productImageByProductIds.get(orderItem.Product2Id);
                        }
                        orderItemResponseList.add(orderItemResponse);
                       
                    }
                    System.debug('orderItemResponseList --->'+orderItemResponseList);
                    OrderSummary orderSummary = [Select Id, SalesStoreId,OriginalOrderId,TotalAmount,GrandTotalAmount,TotalTaxAmount,TotalDeliveryAmount from OrderSummary where OriginalOrderId=:order.Id];
                    System.debug('orderSummary --->'+orderSummary);
                    CartCheckoutSession checkoutSession = [SELECT Id, WebCartId FROM CartCheckoutSession  WHERE OrderId = :orderSummary.OriginalOrderId AND IsArchived = FALSE];

                    CartDeliveryGroup cartDeliveryGroup = [Select Id, DeliverToCity,DeliverToStreet,DeliverToCountry,DeliverToState,DeliverToPostalCode,DeliveryMethod.Name from CartDeliveryGroup where CartId=:checkoutSession.WebCartId];

                    System.debug('orderItemResponseList --->'+orderItemResponseList);
                    B2B2C_OrderResponse response = new B2B2C_OrderResponse();
                    response.orderNumber = order.OrderNumber;
                    response.createdDate = order.CreatedDate.format('MM/dd/yyyy hh:mm:ss');
                    response.orderTotal = order.TotalAmount;
                    response.status = order.Status;
                    response.orderId = order.Id;
                    response.orderSummaryId = orderSummary.Id;
                    response.webStoreId = orderSummary.SalesStoreId;
                    response.totalDeliveryAmount = orderSummary.TotalDeliveryAmount;
                    response.totalTaxAmount = orderSummary.TotalTaxAmount;
                    response.grandTotal = orderSummary.GrandTotalAmount;
                    response.deliveryCity = cartDeliveryGroup.DeliverToCity;
                    response.deliveryState = cartDeliveryGroup.DeliverToState;
                    response.deliveryPostalCode = cartDeliveryGroup.DeliverToPostalCode;
                    response.deliveryCountry = cartDeliveryGroup.DeliverToCountry;
                    response.deliveryMethod = cartDeliveryGroup.DeliveryMethod.Name;
                    response.deliveryStreet = cartDeliveryGroup.DeliverToStreet;
                    response.deliveryStatus = 'Fully Delivered';
                    response.orderItemList.addAll(orderItemResponseList);
                    returnedData.put('orderData',response);
                    returnedData.put('isSuccess',true);
                }else{
                    returnedData.put('isSuccess',false);
                    returnedData.put('message','Did not get any Order with order Id : '+orderId);
                }
            }else{
                returnedData.put('isSuccess',false);
                returnedData.put('message','Order Id can not be blank');
            }
        }catch(Exception e){
            returnedData.put('isSuccess',false);
            System.debug('Exception :'+e+'--at line number :'+e.getLineNumber());
            returnedData.put('message','Exception : '+e.getMessage());
        }
        return JSON.serialize(returnedData);
    }

    global String reOrder(String inputData){
        B2B2C_OrderHistoryService orderService = new B2B2C_OrderHistoryService();
        return orderService.startReOrder(inputData);
    }
}