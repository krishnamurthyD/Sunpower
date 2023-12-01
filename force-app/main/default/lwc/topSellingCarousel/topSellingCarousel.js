import { LightningElement,track,api } from 'lwc';
import {loadStyle,loadScript} from 'lightning/platformResourceLoader';
import bootStrap from '@salesforce/resourceUrl/bootstrap';

import getTopSellingProducts from '@salesforce/apex/topSellingsController.getTopSellingProducts';


export default class TopSellingCarousel extends LightningElement {
   results;
    error;
    product; 
    baseurl="https://lwc10110-dev-ed.lightning.force.com";
   

connectedCallback(){
   // alert('cc');
      getTopSellingProducts()
      .then(result => {
          this.results = result; 
          this.product=JSON.parse(this.results).products;
          // alert(this.results.products[0]);
          // alert(JSON.stringify(this.results.products[0].defaultImage.url) );
          console.log(JSON.parse(this.results).products);
          console.log('OUTPUT 1: '+JSON.stringify(this.product));
          for(let i = 0; i < JSON.parse(this.results).products.length; i++) {
            // console.log('OUTPUT : ',count);
            // console.log('OUTPUT2 : '+this.product[i].defaultImage.url);
            // count=count+1
          this.product[i].defaultImage.url= this.baseurl+this.product[i].defaultImage.url ;
          
          // console.log('OUTPUT 3: '+this.product.defaultImage.url);
          //  console.log('OUTPUT : ',count);
          }
          
      })
      .catch(error => {
        //alert(error);
          this.error = error;``
          console.log(error);
      });
      
}
renderedCallback(){
  Promise.all([
      loadScript(this,bootStrap +'/bootstrap-5.1.3-dist/js/bootstrap.js'),
     // loadScript(this,jQuery),
      loadStyle(this,bootStrap +'/bootstrap-5.1.3-dist/css/bootstrap.min.css')
  ]).then(()=>{
      console.log('loaded');
  })
  }


}