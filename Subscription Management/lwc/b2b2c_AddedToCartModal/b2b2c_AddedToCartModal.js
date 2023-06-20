import { api } from 'lwc';
import LightningModal from 'lightning/modal';

export default class B2b2c_AddedToCartModal extends LightningModal {
    
    handleContinueShoppingClick(){
        this.dispatchEvent(new CustomEvent('continueshopping'), {target:this});
    }

    handleViewCartClick(){
        this.dispatchEvent(new CustomEvent('viewcart'), {target:this});
    }
}