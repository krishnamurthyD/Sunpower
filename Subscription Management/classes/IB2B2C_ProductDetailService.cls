public interface IB2B2C_ProductDetailService {
    B2B2C_ProductDetail.Response getProduct(B2B2C_ProductDetail.Request request);
    B2B2C_AddToCart.Response addToCart(B2B2C_AddToCart.Request request);
}