public interface IB2B2C_StoreLocatorService {

    List<B2B2C_LocationWrapper> fetchLocations(Integer distance, String unit, Decimal userLatitude, Decimal userLongitude);
    List<B2B2C_LocationWrapper> fetchPreferredStore(Integer distance, String unit, Decimal userLatitude, Decimal userLongitude);
    void updateDefaultStore(Id storeId);
    void updateLocations();
}