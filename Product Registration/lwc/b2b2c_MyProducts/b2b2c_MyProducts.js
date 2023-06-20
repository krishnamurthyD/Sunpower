import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

import getMyRegisteredProducts from '@salesforce/apex/B2B2C_MyProductsController.getMyRegisteredProducts';
import communityPath from '@salesforce/community/basePath';

export default class B2b2c_MyProducts extends NavigationMixin(LightningElement) {
    @api searchIconUrl = '';
    @api showTotalProductCount;
    @api showPurchaseWarrantyButton;
    @api showPartsAndAccessoriesButton;
    @api registeredProducts;
    @api allRegisteredProducts;
    @api serviceClassName;
    @api seachedValue = '';
    totalProductCount = 0;
    registerNewProductPageLink = window.location.origin+communityPath+'/product-registration';

    get options() {
        return [
            { label: 'Recent Orders', value: 'PurchaseDateDESC' },
            { label: 'Oldest Orders', value: 'PurchaseDateASC' },
            { label: 'Product Name (A-Z)', value: 'ProductNameASC' },
            { label: 'Product Name (Z-A)', value: 'ProductNameDESC' },
        ];
    }

    handleChange(event) {
        this.value = event.detail.value;
    }

    connectedCallback(){
        this.searchIconUrl = communityPath + '/assets/icons/utility-sprite/svg/symbols.svg#search';
        getMyRegisteredProducts({serviceClassName: this.serviceClassName})
        .then(data => {
            if(data) {
                data.prodInfo.forEach(prod => {
                    prod.productURL = window.location.origin+communityPath+'/product/'+prod.productId;
                    if(prod.productImageURL.includes('/cms/')) {
                        prod.productImageURL = communityPath + '/sfsites/c' + prod.productImageURL;
                    }
                    if(prod.warrantyEndDate=='None' || prod.warrantyEndDate=='No warranties available') {
                        prod.warrantyLabel = 'Warranty';
                    } else {
                        prod.warrantyLabel = 'Warranty Expiration';
                    }
                    prod.showSerialNumberField = false;
                    prod.showInvoiceNumberField = false;
                    if(prod.productSerialNumber) {
                        prod.showSerialNumberField = true;
                    }
                    if(prod.invoiceNumber) {
                        prod.showInvoiceNumberField = true;
                    }
                });
                this.registeredProducts = data.prodInfo;
                this.allRegisteredProducts = data.prodInfo;
                this.totalProductCount = this.registeredProducts.length;
                console.log('[RB] - b2b2c_MyProducts.connectedCallback :: this.registeredProducts => ' + JSON.stringify(this.registeredProducts));
            }
        }).catch(error=> {
            //Show toast message
            console.log('[RB] - b2b2c_MyProducts.connectedCallback :: error => ' + JSON.stringify(error));
        });
    }
    
    filterResult(e) {
        let PATTERN = e.target?.value;
        this.registeredProducts = this.allRegisteredProducts;
        this.registeredProducts = this.registeredProducts.filter(function (data) { 
            return (data.productName.toLowerCase().includes(PATTERN.toLowerCase()) == true || data.productSKU.toLowerCase().includes(PATTERN.toLowerCase()) == true); 
            });
        this.totalProductCount = this.registeredProducts.length;
    }

    sortResult(e) {
        let sortingValue = e.target?.value;
        
        if(sortingValue == 'PurchaseDateDESC') {
            this.registeredProducts = this.registeredProducts.sort((a, b) => {
                                            if (this.getDate(a.purchaseDate) > this.getDate(b.purchaseDate)) {
                                                return -1;
                                            }
                                        });
        } else if(sortingValue == 'PurchaseDateASC') {
            this.registeredProducts = this.registeredProducts.sort((a, b) => {
                                            if (this.getDate(a.purchaseDate) < this.getDate(b.purchaseDate)) {
                                                return -1;
                                            }
                                        });
        } else if(sortingValue == 'ProductNameASC') {
            this.registeredProducts = this.registeredProducts.sort((a, b) =>  a.productName.localeCompare(b.productName));
        } else if(sortingValue == 'ProductNameDESC') {
            this.registeredProducts = this.registeredProducts.sort((a, b) =>  b.productName.localeCompare(a.productName));
        }
        this.totalProductCount = this.registeredProducts.length;
    }

    getDate(strDate) {
        //Purchase Date: 12/01/2022
        var parts =strDate.split('/');
        return new Date(parts[2], parts[0] - 1, parts[1]);
    }

    purchaseWarranty(e){
        let productID = e.target?.value;
        if(productID) {
            this[NavigationMixin.GenerateUrl]({
                type: 'standard__webPage',
                attributes: {
                    url: window.location.origin+communityPath+'/product/'+productID
                }
            }).then(generatedUrl => {
                window.open(generatedUrl, "_self");
            });
        }
    }

    searchSKU(e){
        let productSKU = e.target?.value;
        this[NavigationMixin.GenerateUrl]({
            type: 'standard__webPage',
            attributes: {
                url: window.location.origin+communityPath+'/global-search/'+productSKU
            }
        }).then(generatedUrl => {
            window.open(generatedUrl, "_self");
        });
    }
}