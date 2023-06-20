global with sharing class B2B2C_OrderHistoryService implements IB2B2C_OrderHistoryService  {
    
    global String getMyOrders(String inputData){

        List<B2B2C_OrderResponse> responseList = new List<B2B2C_OrderResponse>();
        Map<String, Object> returnedData = new Map<String, Object>();
        System.debug('inputData--->'+inputData);
        Map<String, Object> requestData = (Map<String, Object>) JSON.deserializeUntyped(inputData);
        String userId = (String)requestData.get('userId');
        String sortString = (String)requestData.get('sortString');
        System.debug('userId--->'+userId);
        try{
            if(String.isNotBlank(userId)){
                String queryString = ' Select Id,CreatedDate, OrderNumber,Status,TotalAmount from Order ';
                String  whereClause = ' where CreatedById=: userId ';
                String orderAndLimitString = '';
                if(String.isNotBlank(sortString)){
                    if(sortString == 'PurchaseDateDESC'){
                        orderAndLimitString =  ' order by createdDate desc';
                    }else if(sortString == 'PurchaseDateASC'){
                        orderAndLimitString =  ' order by createdDate asc';
                    }else if(sortString == 'ProductNameDESC'){
                        orderAndLimitString =  ' order by OrderNumber desc';
                    }else if(sortString == 'OrderTotalDesc'){
                        orderAndLimitString =  ' order by TotalAmount desc';
                    }
                }else{
                    orderAndLimitString =  ' order by createdDate desc';
                }
                String finalQuery = queryString + whereClause + orderAndLimitString;
                List<Order> orderList  = (List<Order>)Database.query(finalQuery);
                System.debug('orderList--->'+orderList);
                if(orderList.size() > 0){
                    List<String> orderIds = new List<String>();
                    for(Order order : orderList){
                        orderIds.add(order.Id);
                    }

                    List<OrderItem> orderItemList = [Select Id,Product2Id,Product2.Name, Quantity,UnitPrice,ListPrice,OrderId from OrderItem where OrderId IN: orderIds AND Type !=  'Delivery Charge'];
                    System.debug('orderItemList--->'+orderItemList);
                    List<B2B2C_OrderItemResponse> orderItemResponseList = new List<B2B2C_OrderItemResponse>();
                   
                    Map<String,B2B2C_OrderItemResponse> orderIdOrderItemRes = new Map<String,B2B2C_OrderItemResponse>();
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
                        orderItemResponse.orderItemId = orderItem.Id;
                        if(productImageByProductIds.containsKey(orderItem.Product2Id)) {
                            orderItemResponse.productImageURL = productImageByProductIds.get(orderItem.Product2Id);
                        }
                        orderItemResponseList.add(orderItemResponse);
                       
                    }
                    System.debug('orderItemResponseList --->'+orderItemResponseList);
                    List<OrderSummary> orderSummaryList = [SELECT Id, SalesStoreId,OriginalOrderId FROM OrderSummary  WHERE OriginalOrderId IN : orderIds];
                    Map<String,String> orderIdOrderSummaryIdMap = new Map<String,String>();
                    Map<String,String> orderIdSalesStoreIdMap = new Map<String,String>();
                    for(OrderSummary orderSummary : orderSummaryList){
                        orderIdOrderSummaryIdMap.put(orderSummary.OriginalOrderId, orderSummary.Id);
                        orderIdSalesStoreIdMap.put(orderSummary.OriginalOrderId, orderSummary.SalesStoreId);
                    }
                    for(Order order : orderList){
                        B2B2C_OrderResponse response = new B2B2C_OrderResponse();
                        response.orderNumber = order.OrderNumber;
                        response.createdDate = order.CreatedDate.format('MM/dd/yyyy hh:mm:ss');//order.CreatedDate;
                        response.orderTotal = order.TotalAmount;
                        response.status = order.Status;
                        response.orderId = order.Id;
                        response.webStoreId = orderIdSalesStoreIdMap.get(order.Id);
                        response.orderSummaryId = orderIdOrderSummaryIdMap.get(order.Id);
                        for(B2B2C_OrderItemResponse orderItemResp : orderItemResponseList){
                            System.debug('orderItemResp --->'+orderItemResp);
                           if(orderItemResp.orderId == order.Id){
                                response.orderItemList.add(orderItemResp);
                           }

                        }
                        System.debug('response --->'+response);
                        //response.isSuccess = true;
                        responseList.add(response);
                    }
                    System.debug('responseList --->'+responseList);
                    returnedData.put('orderHistoryModel',responseList);
                    returnedData.put('isSuccess',true);
                }else{
                    //response.message = 'Did not get any order. ';
                    returnedData.put('isSuccess',false);
                    returnedData.put('message','Did not get any order.');
                }
            }else{
                returnedData.put('isSuccess',false);
                returnedData.put('message','User Id can not be blank.');
            }
        }catch(Exception e){
            System.debug('Exception ->'+e.getMessage()+'---> at line Number --->'+e.getLineNumber());
            returnedData.put('isSuccess',false);
        }
        return JSON.serialize(returnedData);
    }

    global String startReOrder(String inputData){

        List<B2B2C_OrderResponse> responseList = new List<B2B2C_OrderResponse>();
        Map<String, Object> returnedData = new Map<String, Object>();
        System.debug('inputData--->'+inputData);
        Map<String, Object> requestData = (Map<String, Object>) JSON.deserializeUntyped(inputData);
        String webStoreId = (String)requestData.get('webStoreId');
        String orderSummaryId = (String)requestData.get('orderSummaryId');
        String userId = (String)requestData.get('userId');
        Boolean updateCart = (Boolean)requestData.get('updateCart');
        returnedData.put('cartAlreadyExist',false);
        try{
            List<WebCart> webCartList = [Select Id from WebCart where CreatedById=:userId AND Status != 'Closed'];
            System.debug('webCartList--->'+webCartList);
            if(webCartList.size() <= 0 || updateCart){
                if(webCartList.size() > 0 && updateCart){
                    ConnectApi.CommerceCart.deleteCart(webStoreId, null, webCartList.get(0).Id); 
                }
                ConnectApi.CartInput cartInput = new ConnectApi.CartInput();
                cartInput.currencyIsoCode = 'USD';

                ConnectApi.CartSummary cartSummary = ConnectApi.CommerceCart.createCart(webStoreId, cartInput); 
                System.debug('cartSummary--->'+cartSummary);
                System.debug('cartId--->'+cartSummary.cartId );
                ConnectApi.orderToCartInput orderToCartInputObj = new ConnectApi.orderToCartInput();
                orderToCartInputObj.cartStateOrId  = cartSummary.cartId;

                ConnectApi.OrderToCartResult orderToCartResult = ConnectApi.CommerceBuyerExperience.addOrderToCart(
                    webstoreId, 
                    orderSummaryId, 
                    orderToCartInputObj);
                System.debug('orderToCartResult--->'+orderToCartResult);
                returnedData.put('isSuccess',true);
                returnedData.put('orderToCartResult',orderToCartResult);
            }else{
                returnedData.put('isSuccess',false);
                returnedData.put('cartAlreadyExist',true);
            }
        }catch(Exception e){
            System.debug('Exception ->'+e.getMessage()+'---> at line Number --->'+e.getLineNumber());
            returnedData.put('isSuccess',false);
            returnedData.put('message',e.getMessage());
        }
        return JSON.serialize(returnedData);
    }

}