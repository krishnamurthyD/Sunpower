global with sharing class B2B2C_OrderDetail {
    @AuraEnabled
    global static Object getOrderDetail(String inputData, String serviceClassName){
        Type serviceType = Type.forName(serviceClassName);
        B2B2C_OrderDetailService serviceClass = (B2B2C_OrderDetailService)serviceType.newInstance();
        return serviceClass.getOrderDetail(inputData);
    }

    @AuraEnabled
    global static Object reOrder(String inputData, String serviceClassName){
        Type serviceType = Type.forName(serviceClassName);
        B2B2C_OrderDetailService serviceClass = (B2B2C_OrderDetailService)serviceType.newInstance();
        return serviceClass.reOrder(inputData);
    }
}