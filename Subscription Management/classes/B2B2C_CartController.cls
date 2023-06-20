public without sharing class B2B2C_CartController {
	@AuraEnabled(cacheable=true)
    public static B2B2C_Cart.Response getCartItems(B2B2C_Cart.Request request, String className) {
        Type type = Type.forName('B2B2C_CartService');
        //Type type = Type.forName(className);
        IB2B2C_CartService productDetailController = (IB2B2C_CartService)type.newInstance();
        return productDetailController.getCartItems(request);
        
    }
    
    @AuraEnabled
    public static B2B2C_Cart.Response deleteCartItem(B2B2C_DeleteCartItem.Request request, String className) {
        Type type = Type.forName('B2B2C_CartService');
        //Type type = Type.forName(className);
        IB2B2C_CartService productDetailController = (IB2B2C_CartService)type.newInstance();
        return productDetailController.deleteCartItem(request);
        
    }
    
    @AuraEnabled
    public static B2B2C_Cart.Response updateCartItem(B2B2C_UpdateCartItem.Request request, String className) {
        Type type = Type.forName('B2B2C_CartService');
        //Type type = Type.forName(className);
        IB2B2C_CartService productDetailController = (IB2B2C_CartService)type.newInstance();
        return productDetailController.updateCartItem(request);
        
    }
}