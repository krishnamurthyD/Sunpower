public interface IB2B2C_CartService {
	B2B2C_Cart.Response getCartItems(B2B2C_Cart.Request request);
    B2B2C_Cart.Response deleteCartItem(B2B2C_DeleteCartItem.Request request); 
    B2B2C_Cart.Response updateCartItem(B2B2C_UpdateCartItem.Request request);
    
}