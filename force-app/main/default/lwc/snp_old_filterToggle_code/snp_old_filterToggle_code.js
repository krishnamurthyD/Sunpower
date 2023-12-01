import { LightningElement ,track ,api ,wire} from 'lwc';
import communityId from '@salesforce/community/Id';
import getSubCategoryId from '@salesforce/apex/SNP_CheckingForSubCategory.getCategoryId';

import BOOTSTRAP from '@salesforce/resourceUrl/BOOTSTRAP';
import {loadStyle,loadScript} from 'lightning/platformResourceLoader';
 /**
 * @slot Filters
  *@slot SortBySlot
  *@slot PoductTileSlot
  *@slot PaginationSlot
  *@slot PoductTileSlotOff
  *@slot TrustMessageSlot
  *@slot TrustMessageSlotOff
*/

export default class Snp_old_filterToggle_code extends LightningElement {
  @api categoryId ;
  @track showToggleButton = true;
  @track showSubCategryProducts = true;
  @track showTrustMessages = true;
  @track showSubCategory = false;

  connectedCallback(){
    //  setTimeout(()=>{
    //   this.template.querySelector('.slds-modal .slds-modal__container .slds-modal__content slot div.slds-grid > div:nth-child(2) > button').innerText='View Basket';
    //  },2000);
  }
  
  renderedCallback() {
    if(window.innerWidth<768){
      this.template.querySelector('button[title="Filters"]').addEventListener('click',function(){
        this.template.querySelector('body').setAttribute('style','overflow:hidden;');
        console.log('filter button clicked', this.template.querySelector('body'));
      });
    }
  }


  @wire(getSubCategoryId,{
    catgoryIdFormJs:'$categoryId',
  })ShowFilterSection({ data, error }) {
    // alert(this.categoryId)
    // alert(data);
    if (data) {
      this.showSubCategory = true;
      // alert(data)
    }else if (error) {
      // alert(error)
    //  this.showSubCategory = false;
    //  alert('not working')
    }else{
      this.showSubCategory = false;
    }

  }



  mobileToggleFilterSection(){
    this.template.querySelector(".mobile-toggle-button-outer ").classList.toggle('mobile-switch-toggle');
    this.template.querySelector(".filter-bottom ").classList.toggle('mobile-filter-bottom-modify');
    // if(window.innerWidth <= 768){
      this.template.querySelector('button[title="Filters"]').click();
      // this.template.querySelector('.cancel-facets-dialog').addEventListener('click',function() {
      //   this.template.querySelector('.toggle-button-inner').click();
      // });
      console.log('cancel BUTTON', this.template.querySelector('.cancel-facets-dialog'));
      console.log('cancel BUTTON', this.template.querySelector('button[title="Filters"]'));
    // }

  }

    
    toggleCheckbox(event){
      // this.template.querySelector(".toggle-button-outer").classList.toggle('switch-on-toggle');
      console.log(event.target.classList);
      this.template.querySelector(".filter-section").classList.toggle('filter-section-modify');
      this.template.querySelector(".toggle-wrapper").classList.toggle('toggle-wrapper-modify');
      // this.template.querySelector(".clear-filters").classList.toggle('clear-filters-modify');
      this.template.querySelector(".filter-bottom").classList.toggle('filter-bottom-modify');
      this.template.querySelector(".filter-title").classList.toggle('filter-title-modify');
      this.template.querySelector(".product-listing-section").classList.toggle('product-listing-section-modify');
      this.showSubCategryProducts = !this.showSubCategryProducts;
      this.showTrustMessages = !this.showTrustMessages;
      console.log(this.categoryId);

    }
  
    handleClick() {
      // Your click event handler logic goes here
      console.log('Button clicked!');
    }

   

    handelSortBy(){
      console.log(this.template.querySelector('.sortby-filters'));
      console.log(this.template.querySelectorAll('lightning-base-combobox-item'));
      // console.log(this.template.querySelector('.sortby-filters'));
      // console.log(this.template.querySelector('[data-component-id="searchSortMenu-d797"] .slds-listbox'));
    
    }
}