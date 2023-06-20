public without sharing class B2B2C_StoreLocator {

    @AuraEnabled (cacheable=true)
    public static List<B2B2C_LocationWrapper> fetchLocations(Integer distance, String unit, Decimal userLatitude, Decimal userLongitude, String serviceClassName){
        Type serviceType = Type.forName(serviceClassName);
        IB2B2C_StoreLocatorService serviceClass = (IB2B2C_StoreLocatorService)serviceType.newInstance();
        return serviceClass.fetchLocations(distance, unit, userLatitude, userLongitude);
    }

    @AuraEnabled (cacheable=true)
    public static List<B2B2C_LocationWrapper> fetchPreferredStore(Integer distance, String unit, Decimal userLatitude, Decimal userLongitude, String serviceClassName){
        Type serviceType = Type.forName(serviceClassName);
        IB2B2C_StoreLocatorService serviceClass = (IB2B2C_StoreLocatorService)serviceType.newInstance();
        return serviceClass.fetchPreferredStore(distance, unit, userLatitude, userLongitude);
    }

    @AuraEnabled
    public static void updateDefaultStore(Id storeId, String serviceClassName){
        Type serviceType = Type.forName(serviceClassName);
        IB2B2C_StoreLocatorService serviceClass = (IB2B2C_StoreLocatorService)serviceType.newInstance();
        serviceClass.updateDefaultStore(storeId);
    }

    @AuraEnabled
    public static void updateLocations(String serviceClassName){
        Type serviceType = Type.forName(serviceClassName);
        IB2B2C_StoreLocatorService serviceClass = (IB2B2C_StoreLocatorService)serviceType.newInstance();
        serviceClass.updateLocations();
    }
}