public without sharing class B2B2C_MySubscriptionsController {
    
    @AuraEnabled
    public static B2B2C_MySubscriptionsModal getMySubscriptionProducts(String serviceClassName){
        Type serviceType = Type.forName(serviceClassName);
        IB2B2C_MySubscriptionsService serviceClass = (IB2B2C_MySubscriptionsService)serviceType.newInstance();
        return (B2B2C_MySubscriptionsModal)serviceClass.getMySubscriptionProducts();
    }

    @AuraEnabled
    public static B2B2C_MySubscriptionsModal updateSubscriptionInformation(B2B2C_MySubscriptionsModal subscriptionInfo, String serviceClassName){
        Type serviceType = Type.forName(serviceClassName);
        IB2B2C_MySubscriptionsService serviceClass = (IB2B2C_MySubscriptionsService)serviceType.newInstance();
        return (B2B2C_MySubscriptionsModal)serviceClass.updateSubscriptionInformation(subscriptionInfo);
    }

    @AuraEnabled
    public static List<B2B2C_SubscriptionOption> getSubscriptionOptions(String subscriptionProductId, String serviceClassName){
        Type serviceType = Type.forName(serviceClassName);
        IB2B2C_MySubscriptionsService serviceClass = (IB2B2C_MySubscriptionsService)serviceType.newInstance();
        return (List<B2B2C_SubscriptionOption>)serviceClass.getSubscriptionOptions(subscriptionProductId);
    }
}