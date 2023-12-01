public with sharing class contactsController {
    @AuraEnabled(Cacheable=true)
    public static List<Contact> getContactLists() {
        return [SELECT NAME FROM Contact];
    }
}