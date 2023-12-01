import { LightningElement, wire, api, track } from 'lwc';
import getUserContent from '@salesforce/apex/ManagedContentController.getContent';
import getProductId from '@salesforce/apex/SNP_NewlyLaunchedProductController.getProductIdFromManagedContentKey';
import basePath from '@salesforce/community/basePath';
import { NavigationMixin } from 'lightning/navigation';



export default class SnpNewlyLaunchedSection extends NavigationMixin(LightningElement) {
    @api contentId;
    @api title;
    @track url;
    _cmsData;
    productId;

    // Wire method to fetch content based on the provided parameters
    @wire(getUserContent, {
        contentId: '$contentId',
        page: 0,
        pageSize: 1,
        language: 'en_US',
        filterby: ''
    })
    wiredContent({ data, error }) {

        if (data) {

            this._cmsData = data;
            this.url = `${basePath}/sfsites/c${this._cmsData.source?.unauthenticatedUrl ?? ''}`;

        }
        else if (error) {
            console.error('Error: ' + JSON.stringify(error));
        }
    }




    // Handles the product click action
    async handleProductClick() {
        await this.getProductInfo();
        if (this.productId) { // Check if productId is defined after awaiting
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: this.productId,
                    objectApiName: 'Product2',
                    actionName: 'view'
                }
            });
        } else {
            console.error('Product ID is undefined.');
        }


    }

    async getProductInfo() {
        try {
            const result = await getProductId({ managedcontentKey: this.contentId });
            this.productId = result;
        } catch (error) {
            console.error('Error in getProductInfo: ', JSON.stringify(error));
        }
    }
}