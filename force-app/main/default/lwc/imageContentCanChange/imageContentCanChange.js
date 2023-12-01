import { LightningElement,wire } from 'lwc';
import getContentFromCms from '@salesforce/apex/snp_sineInPageController.getContentFromCms';
import basePath from '@salesforce/community/basePath';

export default class ImageContentCanChange extends LightningElement {
    @wire(getContentFromCms,{
        contentId: '$contentId',
        page: 0,
        pageSize: 1,
        language: 'en_US',
        filterby: ''
    })
    wiredContent({ data, error }) {
        if(data){
            this._cmsData = data;
            //alert(JSON.stringify(data));

            this.url = 
                    basePath + 
                    '/sfsites/c' +
                    this._cmsData.source.unauthenticatedUrl;  
        }
            if (error) {
                console.log('Error :' +JSON.stringify(error));
            }
    }
}