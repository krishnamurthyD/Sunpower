global class B2B2C_ProductRegistrationDAO {
    global static Product2 getProductInfo(String productCode) {
        List<Product2> prodList = [SELECT Id, Name FROM Product2 WHERE ProductCode = :productCode WITH SECURITY_ENFORCED];
        return (prodList.size()>0)?prodList[0]:null;
    }

    global static User getLoggedInUserInfo(String userId) {
        return [SELECT ContactId, AccountId FROM User WHERE Id=:userId WITH SECURITY_ENFORCED];
    }

    global static void insertRecords(List<SObject> newRecords) {
        insert newRecords;
    }
}