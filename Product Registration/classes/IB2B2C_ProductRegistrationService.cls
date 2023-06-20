global interface IB2B2C_ProductRegistrationService {
    boolean validateSerialNumber(String serialNumber);
    boolean validateProductCode(String productCode);
    boolean validatePurchaseDate(Date purchaseDate, Integer pastDateMargin);
    Object registerProduct(Object productData);
}