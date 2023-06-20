public without sharing class B2B2C_ProductDetailController {
    @AuraEnabled(cacheable=true)
    public static B2B2C_ProductDetail.Response getProduct(B2B2C_ProductDetail.Request request, String className) {
        Type type = Type.forName('B2B2C_ProductDetailService');
        //Type type = Type.forName(className);
        IB2B2C_ProductDetailService productDetailController = (IB2B2C_ProductDetailService)type.newInstance();
        return productDetailController.getProduct(request);
    }
    
    @AuraEnabled
    public static B2B2C_AddToCart.Response addToCart(B2B2C_AddToCart.Request request, String className) {
        Type type = Type.forName('B2B2C_ProductDetailService');
        //Type type = Type.forName(className);
        IB2B2C_ProductDetailService productDetailController = (IB2B2C_ProductDetailService)type.newInstance();
        return productDetailController.addToCart(request);
    }

}