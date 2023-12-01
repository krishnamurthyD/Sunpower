import { LightningElement,api,track } from 'lwc';
import userId from '@salesforce/user/Id';
import communityId from '@salesforce/community/Id';
import createWishList from '@salesforce/apex/AddToWishListControllerTwo.createWishList';

export default class AddToWishListComp extends LightningElement {
    @api recordId;
    @track response;

    handleAddToWishListController(){
        alert(userId);
        alert(communityId);
        alert(this.recordId);
       createWishList({currentUserId:userId,currentCommunityId:communityId,productId:this.recordId})
            .then(result => {
                this.response=result;
                alert('Response'+JSON.stringify(this.response));
              
            })
            .catch(error => {
                // TODO Error handling
                alert('Something went wrong !')
            });
    }
}