import { LightningElement, api } from 'lwc';
import getCartItems from '@salesforce/apex/B2B2C_CartController.getCartItems';
import deleteCartItem from '@salesforce/apex/B2B2C_CartController.deleteCartItem';
import updateCartItem from '@salesforce/apex/B2B2C_CartController.updateCartItem';
import communityPath from '@salesforce/community/basePath';
export default class B2b2c_CartPage extends LightningElement {
    @api enableNoOfDeliveries = false;
    @api className; 
    _cartDetail;

    isLoaded = false;

    get toast(){
        return this.template.querySelector('c-b2b2c_-toast');
    }

    get cartDetail(){
        return this._cartDetail;
    }
    set cartDetail(data){
        this._cartDetail = JSON.parse(JSON.stringify(data));
        this._cartDetail.cartItems = 
        this._cartDetail.cartItems ?
        this._cartDetail.cartItems?.map(
            cartItem => { 
                if(cartItem.productClass == 'Simple'){
                    cartItem.isSimpleProduct = true;
                }else if(cartItem.productClass == 'Deliverable Subscription'){
                    cartItem.isSubscriptionProduct = true;
                }else if(cartItem.productClass == 'Related'){
                    cartItem.isRelatedProduct = true;
                }

                if(cartItem?.productDetails?.thumbnailImage?.url && cartItem.productDetails.thumbnailImage.url.includes('/cms/')) {
                    cartItem.productDetails.thumbnailImage.url = communityPath + '/sfsites/c' + cartItem.productDetails.thumbnailImage.url;            
                }

                cartItem.isListPriceDiff = cartItem?.listPrice === null? false: cartItem?.listPrice != cartItem?.unitAdjustedPrice;

                cartItem.productUrl = communityPath+'/product/'+cartItem.productDetails.productId;
                
                if(Array.isArray(cartItem.subscriptionOptions)){
                    cartItem.subscriptionOptionCombobox = [];
                    cartItem.subscriptionOptions.forEach(subscriptionOption => {
                        cartItem.subscriptionOptionCombobox.push(
                            {
                                label: subscriptionOption.intervalLabel,
                                value : subscriptionOption.id
                            }
                        );
                    });
                }
                
                return cartItem;
            }
        ) :
        null;
    }


    connectedCallback(){
        this.getCartItems();
    }

    getCartItems(){
        this.isLoaded = false;
        return getCartItems({
            className : this.className
        }).then(data => {
            console.log('getProduct data ', data);
            if(data){
                this.cartDetail = data;
            }
            console.log('cartDetail ', this.cartDetail);
            this.isLoaded = true;
        }).catch(error => {
            console.log('getProduct error ', error);
            this.toast.showCustomNoticeWithParams('Get Cart Error', this.getErrorMessage(error), 'error', '', true );
            this.isLoaded = true;
        });
    }

    updateCartItem(request){
        this.isLoaded = false;
        return updateCartItem({
            request: request,
            className : this.className
        }).then(data => {
            console.log('getProduct data ', data);
            if(data){
                this.cartDetail = data;
            }
            console.log('cartDetail ', this.cartDetail);
            this.isLoaded = true;
        }).catch(error => {
            console.log('getProduct error ', error);
            this.toast.showCustomNoticeWithParams('Update Cart Item Error', this.getErrorMessage(error), 'error', '', true );
            this.isLoaded = true;
        });
    }

    deleteCartItem(request){
        this.isLoaded = false;
        return deleteCartItem({
            request: request,
            className : this.className
        }).then(data => {
            console.log('getProduct data ', data);
            if(data){
                this.cartDetail = data;
            }
            console.log('cartDetail ', this.cartDetail);
            this.isLoaded = true;
        }).catch(error => {
            console.log('getProduct error ', error);
            this.toast.showCustomNoticeWithParams('Delete Cart Item Error', this.getErrorMessage(error), 'error', '', true );
            this.isLoaded = true;
        });
    }

    handleRemove(event){
        console.log('in handleRemove');
        let index = event.target.dataset.index;
        let cartItem = this.cartDetail.cartItems[index];
        let request= {
            cartItemId : cartItem.cartItemId,
            effectiveAccountId : null,
            relatedCartItemIds : cartItem.relatedCartItemIds ? cartItem.relatedCartItemIds : null
        }
        this.deleteCartItem(request);
    }

    handleSubscriptionOptionChange(event){
        console.log('in handleSubscriptionOptionChange', event.detail.value, event.target.dataset.index);
        let index = event.target.dataset.index;
        let cartItem = this.cartDetail.cartItems[index];
        let selectedOption = cartItem.subscriptionOptions.find(
            subscriptionOption => subscriptionOption.id == event.detail.value
        );
        cartItem.selectedOption = {...selectedOption};
        console.log('in handleSubscriptionOptionChange cartdeatil', this.cartDetail)
        let request = {
            cartItemId : cartItem.cartItemId,
            effectiveAccountId : null,
            relatedCartItemIds : cartItem.relatedCartItemIds ? cartItem.relatedCartItemIds : null,
            quantity : cartItem.quantity,
            productClass : cartItem.productClass,
            numberOfDeliveries : cartItem.numberOfDeliveries,
            selectedOption: cartItem.selectedOption
        }
        this.updateCartItem(request);
    }

    handleNoOfDeliveries(event){
        let index = event.target.dataset.index;
        let cartItem = this.cartDetail.cartItems[index];
        if(parseInt(event.detail.value) !== parseInt(cartItem.numberOfDeliveries)){
            cartItem.numberOfDeliveries = event.detail.value;
            console.log('in handleNoOfDeliveries cartdeatil', this.cartDetail);
            let request = {
                cartItemId : cartItem.cartItemId,
                effectiveAccountId : null,
                relatedCartItemIds : cartItem.relatedCartItemIds ? cartItem.relatedCartItemIds : null,
                quantity : cartItem.quantity,
                productClass : cartItem.productClass,
                numberOfDeliveries : cartItem.numberOfDeliveries,
                selectedOption: cartItem.selectedOption
            }
            this.updateCartItem(request);
        }
        
    }
    handleQuantityChange(event){
        let index = event.target.dataset.index;
        let cartItem = this.cartDetail.cartItems[index];
        if(parseInt(event.detail.value) !== parseInt(cartItem.quantity)){
            cartItem.quantity = event.detail.value;
            console.log('in handleQuantity cartdeatil', this.cartDetail);
            let request = {
                cartItemId : cartItem.cartItemId,
                effectiveAccountId : null,
                relatedCartItemIds : cartItem.relatedCartItemIds ? cartItem.relatedCartItemIds : null,
                quantity : cartItem.quantity,
                productClass : cartItem.productClass
            }
            this.updateCartItem(request);
        }
    }


    getErrorMessage(error){
        let errorMessage = 'Unknown error';
        if (Array.isArray(error.body)) {
            errorMessage = error.body.map(e => e.message).join(', ');
        } else if (typeof error.body.message === 'string') {
            errorMessage = error.body.message;
        }
        return errorMessage;
    }
}