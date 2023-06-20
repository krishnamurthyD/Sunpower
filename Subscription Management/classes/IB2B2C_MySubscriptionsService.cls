/**
* @description       : Interface for MySubscriptions Service Class
* @author            : Rohit B
* @group             :
* @last modified on  : 01-30-2023
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
* Modifications Log
* Ver   Date            Author             Modification
* 1.0   24.Jan.2023     Rohit B            Initial Version
**/

global interface IB2B2C_MySubscriptionsService {
    Object getMySubscriptionProducts();
    Object updateSubscriptionInformation(Object requestData);
    Object getSubscriptionOptions(String subscriptionProductId);
    Object insertSubscriptions(Set<Order> Orders);
}