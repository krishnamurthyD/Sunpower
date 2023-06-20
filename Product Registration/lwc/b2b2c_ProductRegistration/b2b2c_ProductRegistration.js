import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

//import custom labels
import Product_Registration_Heading from '@salesforce/label/c.Product_Registration_Heading';
import Serial_Number from '@salesforce/label/c.ProdReg_Serial_Number';
import Find_my_serial_num from '@salesforce/label/c.ProdReg_Find_My_Serial_Number';
import Product_Code from '@salesforce/label/c.ProdReg_Product_Code';
import Purchase_Date from '@salesforce/label/c.ProdReg_Purchase_Date';
import Price_Paid from '@salesforce/label/c.ProdReg_Price_Paid';
import Btn_Continue from '@salesforce/label/c.ProdReg_Btn_Continue';
import ErrMsg_Serial_Number from '@salesforce/label/c.ProdReg_ErrMsg_Serial_Number';
import ErrMsg_Product_Code from '@salesforce/label/c.ProdReg_ErrMsg_Product_Code';
import ErrMsg_Purchase_Date from '@salesforce/label/c.ProdReg_ErrMsg_Purchase_Date';

import registerProduct from '@salesforce/apex/B2B2C_ProductRegistrationController.registerProduct';
import validateSerialNumber from '@salesforce/apex/B2B2C_ProductRegistrationController.validateSerialNumber';
import validateProductCode from '@salesforce/apex/B2B2C_ProductRegistrationController.validateProductCode';
import validatePurchaseDate from '@salesforce/apex/B2B2C_ProductRegistrationController.validatePurchaseDate';

import LOCATE_SERIAL_NUMBER from '@salesforce/resourceUrl/Headphone_Serial_Number';

import communityPath from '@salesforce/community/basePath';
import userId from '@salesforce/user/Id';

export default class B2b2c_ProductRegistration extends NavigationMixin(LightningElement) {
    
    @api isSerialNumberValid = false;
    @api isProductCodeValid = false;
    @api pastDateMargin;
    @api isShowModal = false;
    @api serviceClassName;
    locateSerialNumber = LOCATE_SERIAL_NUMBER;
    find_my_serial_num_header = Find_my_serial_num.replace(/(\w)(\w*)/g,function(g0,g1,g2){return g1.toUpperCase() + g2.toLowerCase();});

    label = {
        Product_Registration_Heading,
        Serial_Number,
        Find_my_serial_num,
        Product_Code,
        Purchase_Date,
        Price_Paid,
        Btn_Continue
    };

    currDate;
    get currentDate(){
        if(this.currDate == undefined)
        {
          this.currDate = new Date().toISOString().substring(0, 10);
        }
        return this.currDate;
    }

    connectedCallback(){
        if(userId == null) {
            this[NavigationMixin.GenerateUrl]({
                type: 'standard__webPage',
                attributes: {
                    url: window.location.origin+communityPath+'/login'
                }
            }).then(generatedUrl => {
                window.open(generatedUrl, "_self");
            });
        }
    }

    verifySerialNumber(e) {
        var serialNumber = e.target?.value;
        let txtSerialNumber = this.template.querySelector("[data-id='txtSerialNumber']");
        if(serialNumber) {
            validateSerialNumber({serialNumber: serialNumber, serviceClassName: this.serviceClassName})
            .then(result => {
                if(result) {
                    txtSerialNumber.setCustomValidity('');
                } else {
                    txtSerialNumber.setCustomValidity(ErrMsg_Serial_Number);
                }
                txtSerialNumber.reportValidity();
            }).catch(error=> {
                //Show toast message
                console.log('[RB] - b2b2c_ProductRegistration.verifySerialNumber :: error => ' + JSON.stringify(error));
            });
        }
    }

    verifyProductCode(e) {
        var productCode = e.target?.value;
        let txtProductCode = this.template.querySelector("[data-id='txtProductCode']");
        txtProductCode.setCustomValidity('');
        if(productCode) {
            validateProductCode({productCode: productCode, serviceClassName: this.serviceClassName})
            .then(result => {
                if(result) {
                    txtProductCode.setCustomValidity('');
                } else {
                    txtProductCode.setCustomValidity(ErrMsg_Product_Code);
                }
                txtProductCode.reportValidity();
            }).catch(error=> {
                //Show toast message
                console.log('[RB] - b2b2c_ProductRegistration.verifyProductCode :: error => ' + JSON.stringify(error));
            });
        }
    }

    verifyPurchaseDate(e) {
        var purchaseDate = e.target?.value;
        let txtPurchaseDate = this.template.querySelector("[data-id='txtPurchaseDate']");
        if(purchaseDate) {
            validatePurchaseDate({purchaseDate: purchaseDate, pastDateMargin: this.pastDateMargin, serviceClassName: this.serviceClassName})
            .then(result => {    
                if(result) {
                    txtPurchaseDate.setCustomValidity('');
                } else {
                    txtPurchaseDate.setCustomValidity(ErrMsg_Purchase_Date);
                }
                txtPurchaseDate.reportValidity();
            }).catch(error=> {
                //Show toast message
                console.log('[RB] - b2b2c_ProductRegistration.verifyPurchaseDate :: error => ' + JSON.stringify(error));
            });
        }
    }
    
    resetErrorMessage(e){
        let dataId = e.target.dataset.id;
        let field = this.template.querySelector("[data-id='" + dataId + "']");
        field.setCustomValidity('');
        field.reportValidity();
    }

    continueButtonClick(e) {
        let txtSerialNumber = this.template.querySelector("[data-id='txtSerialNumber']");
        let txtProductCode = this.template.querySelector("[data-id='txtProductCode']");
        let txtPurchaseDate = this.template.querySelector("[data-id='txtPurchaseDate']");
        let txtPricePaid = this.template.querySelector("[data-id='txtPricePaid']");
        if(txtPricePaid.value=='' || txtPricePaid.value==undefined) {
            txtPricePaid.value = 0.00;
        }
        var prodData = {
            serialNumber: txtSerialNumber.value,
            productCode: txtProductCode.value,
            purchaseDate: txtPurchaseDate.value,
            pastDateMargin: this.pastDateMargin,
            purchasedPrice: txtPricePaid.value
        };
        
        registerProduct({productData: prodData, serviceClassName: this.serviceClassName})
        .then(result => {
            var response = result;
            if(response?.isSuccess){
                this[NavigationMixin.GenerateUrl]({
                    type: 'standard__webPage',
                    attributes: {
                        url: window.location.origin+communityPath+'/product-registration-confirmation'
                    }
                }).then(generatedUrl => {
                    window.open(generatedUrl, "_self");
                });
            } else {
                //Show toast message
            }
        }).catch(error=> {
            //Show toast message
            console.log('[RB] - b2b2c_ProductRegistration.continueButtonClick :: error => ' + JSON.stringify(error));
        });
    }

    showModalPopup(e) {
        this.isShowModal = true;
    }

    closeModalPopup(e) {
        this.isShowModal = false;
    }

    makeTitleBlank(e) {
        console.log('[RB] - makeTitleBlank :: Method Called..');
        /*var buttonQuerySelector = this.template.querySelector("[data-id='helpTextPricePaid']");
        console.log('[RB] - makeTitleBlank :: buttonQuerySelector => ' + buttonQuerySelector);
        console.log('[RB] - makeTitleBlank :: buttonQuerySelector.innerHTML => ' + buttonQuerySelector?.innerHTML);
        console.log('[RB] - makeTitleBlank :: buttonQuerySelector.innerText => ' + buttonQuerySelector?.innerText);*/
        var buttonETarget = e.target;
        console.log('[RB] - makeTitleBlank :: buttonETarget => ' + buttonETarget);
        console.log('[RB] - makeTitleBlank :: buttonETarget.title => ' + buttonETarget?.title);
        console.log('[RB] - makeTitleBlank :: buttonETarget.innerHTML => ' + buttonETarget?.innerHTML);
        console.log('[RB] - makeTitleBlank :: buttonETarget.innerText => ' + buttonETarget?.innerText);
        //buttonETarget.innerText = '';
        
        var buttonByTagAll = this.template.querySelectorAll('button');
        console.log('[RB] - makeTitleBlank :: buttonByTagAll => ' + buttonByTagAll);
        console.log('[RB] - makeTitleBlank :: buttonByTagAll.length => ' + buttonByTagAll.length);
        console.log('[RB] - makeTitleBlank :: buttonByTagAll.title => ' + buttonByTagAll[0]?.title);
        console.log('[RB] - makeTitleBlank :: buttonByTagAll.innerHTML => ' + buttonByTagAll[0]?.innerHTML);
        console.log('[RB] - makeTitleBlank :: buttonByTagAll.innerText => ' + buttonByTagAll[0]?.innerText);
        var buttonByDTagAll = document.querySelectorAll('button');
        console.log('[RB] - makeTitleBlank :: buttonByDTagAll => ' + buttonByDTagAll);
        console.log('[RB] - makeTitleBlank :: buttonByDTagAll.length => ' + buttonByDTagAll.length);
        console.log('[RB] - makeTitleBlank :: buttonByDTagAll.title => ' + buttonByDTagAll[0]?.title);
        console.log('[RB] - makeTitleBlank :: buttonByDTagAll.innerHTML => ' + buttonByDTagAll[0]?.innerHTML);
        console.log('[RB] - makeTitleBlank :: buttonByDTagAll.innerText => ' + buttonByDTagAll[0]?.innerText);
    }
}