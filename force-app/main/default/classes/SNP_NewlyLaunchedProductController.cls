/**
 * Author: Owais Amin Ahanger
 * Description: This controller class will fetch the product Id of a product based on CMS Image/Media .
 * Test Class: 
 */
public class SNP_NewlyLaunchedProductController {
    
    /**
 * Fetches the product ID associated with a given CMS content key.
 *
 * @param managedcontentKey The managed content key corresponding to the CMS image/media.
 * @return String The ID of the product associated with the managed content key.
 * @throws SNP_CustomException if the product image is not found or any other error occurs.
 */

    @AuraEnabled
    public static String getProductIdFromManagedContentKey(String managedcontentKey){
        try{
        String managedContentId=getManagedContentId(
        
        
        );
        String productId=getProductId(managedContentId);
         if(String.isBlank(productId)){
            throw new SNP_CustomException('Image not found ! Select valid product image');
        }
        return productId;
        }
        catch(Exception e){
            throw new SNP_CustomException('Error Occured:- '+e.getMessage());
        }

            
    }
    
    
 /**
 * Retrieves the Managed Content ID from a managed content key.
 *
 * @param managedContentKey The managed content key to query the managed content ID for.
 * @return String The Managed Content ID associated with the managed content key.
 * @throws SNP_CustomException if the managed content cannot be queried.
 */
    private static String getManagedContentId(String managedContentKey){
        try{
            
            String networkId =Network.getNetworkId();  
            ConnectApi.ManagedContentVersionCollection contentCollection = ConnectApi.ManagedContent.getManagedContentByContentKeys(
                networkId,
                new List<String>{ ManagedcontentKey },
                0,
                1,
                'en_US',
                'cms_image',
                false
            );
          
        return contentCollection.items[0].managedContentId;
        }
        catch(Exception e){
            throw new SNP_CustomException('Managed Content Query '+e.getMessage());
        }
         
        
    }
    
    /**
 * Queries for the Product ID associated with a specific Managed Content ID.
 *
 * @param mId The Managed Content ID to find the associated Product ID.
 * @return String The Product ID associated with the Managed Content ID.
 * @throws SNP_CustomException if the image is not associated with any product.
 */
    public static String getProductId(String mId){
        try{
            return [
            SELECT ProductId FROM ProductMedia WHERE ElectronicMediaId=:mId LIMIT 1
            ].ProductId;
        }catch(Exception e){
            throw new SNP_CustomException('Selected Image is not associated with any product');
        }
    }
}