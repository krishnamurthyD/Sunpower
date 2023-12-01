/**
 * 
*@description       : Iconagraphy 
*@author            : Krishnamurthy Donta and Aditya Lenka
*@class             : SNP_ProductAddInfo_controller
*@last modified on  : 06-11-2023
*@last modified by  : 
 */
import { LightningElement , track , api , wire } from 'lwc';
import getProductSpecifications from '@salesforce/apex/SNP_ProductAddInfo_controller.getProductSpecifications';

export default class Iocgraphy extends LightningElement { 


    //for geting the current product id dynamivally from the pdp 
    @api recordId;

    //using list for specifications
    @track SpecificationDataList = [];

    //show Specification wrapper
    @track ShowSpecificationWrapper = false;

    //current attribute of product to be matched with imag
    attributeOfProduct = [];
    attriburtFunctionValue ;

     //Method for geting specifications of the product
     @wire(getProductSpecifications, { productId: '$recordId' })
     getProductSpecification({ error, data }) {
         console.log('pdp record page-s-------->'+this.recordId);
         console.log('pdp record page-s-------->', data);
         console.log('pdp record page-s-------->', error);
    if (error) {
         console.log('productInfo Error- ', JSON.stringify(error));
     } else if (data) {
         this.SpecificationDataList = [];
         console.log('Aditya Lenka specifications->>>>>>>>>>>>>>>>>>>>>>>.' + JSON.stringify(data));

         //for list
         for (let field in data) {
             if (field.endsWith('__c') && data[field] !== 'None') {
                 // Remove the '__c' from the field name and replace '_' with ' '
                 let modifiedField = field.replace('__c', '').replace(/_/g, ' ');
                 this.SpecificationDataList.push({ field: modifiedField, value: data[field] });
             }
         }
         console.log('SpecificationDataList->>>>>>>>>>>>>>>>>>>>>>>.' + JSON.stringify(this.SpecificationDataList));
         if (this.SpecificationDataList.length > 0) {
             this.attributeOfProduct = [];
            //  get the list of attributes for current product
            for(let i=0 ; i<this.SpecificationDataList.length ; i++){
                console.log(this.SpecificationDataList[i].field);
                if(this.SpecificationDataList[i].field != 'Function1'){
                    this.attributeOfProduct.push(this.SpecificationDataList[i].field);
                }
                
            }
            for(let i=0 ; i<this.SpecificationDataList.length ; i++){
                if(this.SpecificationDataList[i].field == 'Function1'){
                    this.attriburtFunctionValue = this.SpecificationDataList[i].field;
                }
            }
            console.log('the attributes present in list', this.attributeOfProduct);
         }
     }
    }
   
}