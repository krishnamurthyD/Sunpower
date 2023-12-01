import { LightningElement,api,wire} from 'lwc';
import getManagedContentByContentKeys from '@salesforce/apex/Snp_Get_Managed_Content.getManagedContentByContentKeys';
export default class Snp_Recommendation_comp extends LightningElement {
     @api strTitle ='Welcome in Salesforce'
     @api contentId
     image
     @api imageurl

     
  @wire( getManagedContentByContentKeys,{ contentkey: '$contentId' })
  wiredData({ error, data }) {
    if (data) {
     console.log('Data', data);
     console.log('^^'+JSON.stringify(data.items[0].contentNodes.source));
     this.image=data.items[0].contentNodes.source;
     console.log(this.image.unauthenticatedUrl);
     this.imageurl=this.image.unauthenticatedUrl;
    } else if (error) {
      console.error('Error:', error);
    }
  }
}