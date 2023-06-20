global with sharing class B2B2C_OrderHistory {
    
    @AuraEnabled
    public static Object getMyOrder(String inputData, String serviceClassName){
        Type serviceType = Type.forName(serviceClassName);
        B2B2C_OrderHistoryService serviceClass = (B2B2C_OrderHistoryService)serviceType.newInstance();
        return serviceClass.getMyOrders(inputData);
    }
    @AuraEnabled
    public static string startReOrder(String inputData, String serviceClassName){
        Type serviceType = Type.forName(serviceClassName);
        B2B2C_OrderHistoryService serviceClass = (B2B2C_OrderHistoryService)serviceType.newInstance();
        return serviceClass.startReOrder(inputData);
    }
}