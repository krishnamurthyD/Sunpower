/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 01-30-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class B2B2C_genricResponseModal {
    public B2B2C_genricResponseModal() {

    }
    @AuraEnabled
    public Boolean isSuccess;
    @AuraEnabled
    public String message;
    @AuraEnabled
    public Object addtionalInfo;
}