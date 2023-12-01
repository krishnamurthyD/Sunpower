import { LightningElement, api, track, wire } from 'lwc';
import basePath from '@salesforce/community/basePath';
import communityId from '@salesforce/community/Id';
import getCategoryBannerImageById from '@salesforce/apex/snpCategoryBannerController.getCategoryBannerImageById';
import getCategoryDescription from '@salesforce/apex/snpCategoryBannerController.getCategoryDescription';

export default class SnpCategoryBanner extends LightningElement {

    @api categoryId; // Property to receive the category ID from category page
    @track imageUrl; // Property to track the category banner image URL
    @track categoryDetails = []; // Property to track the category details data

    @wire(getCategoryBannerImageById, {
        currentCommunityId: communityId,
        categoryId: '$categoryId', // Reactive binding to the categoryId property
    })
    wiredCategoryImages({ data, error }) {
        if (data) {
            this.imageUrl = basePath +
                '/sfsites/c' +
                data.source.unauthenticatedUrl; // Set the image URL based on the retrieved data
        }
        else if (error) {
            console.log('Error' + JSON.stringify(error));
        }
    }

    @wire(getCategoryDescription, {
        categoryId: '$categoryId' // Reactive binding to the categoryId property
    })
    wiredCategoryDetails({ data, error }) {

        if (data) {
            this.categoryDetails = data.map(item => {

                return {
                    id: item.Id,
                    name: item.Name,
                    description: item.Description
                }
            });
            // Map the retrieved data to the categoryDetails property
        }
        else if (error) {
            console.log('Error' + JSON.stringify(error));
        }
    }

}