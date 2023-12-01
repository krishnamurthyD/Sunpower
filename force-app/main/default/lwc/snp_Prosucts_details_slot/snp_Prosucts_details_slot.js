import { LightningElement } from 'lwc';
import BOOTSTRAP from '@salesforce/resourceUrl/BOOTSTRAP';
import {loadStyle,loadScript} from 'lightning/platformResourceLoader';
  /**
 * @slot PromoBanner
  *@slot CompanyLogo
  *@slot StandardNavigationComponent
  *@slot Icons
  *@slot Navigation
*/

export default class Snp_Prosucts_details_slot extends LightningElement {
    connectedCallback(){
        // Promise.all([
        // loadScript(this,BOOTSTRAP +'/bootstrap-5.0.2-dist/js/bootstrap.js'),
        // loadStyle(this,BOOTSTRAP +'/bootstrap-5.0.2-dist/css/bootstrap.min.css'),
        // ]).
        // then(()=>{
        // //alert('success');
        
        // }).catch((error=>{
        // alert('Load Failed');
        // }))
         }  
        }