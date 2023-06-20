import { LightningElement,api,wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

import communityPath from '@salesforce/community/basePath';
import getOrderDetails from "@salesforce/apex/B2B2C_OrderDetail.getOrderDetail";
import reOrder from "@salesforce/apex/B2B2C_OrderDetail.reOrder"; 
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import USER_Id from '@salesforce/user/Id';
// Import custom labels
import replaceCartItems from "@salesforce/label/c.Replace_Cart_Item";

export default class B2b2c_OrderDetails extends NavigationMixin(LightningElement) {
    activeSections = ['shipingaddress', ''];
    activeSectionsMessage = '';
    orderHistory;
    userId = USER_Id;
    @api recordId;
    orderDetails;
    @api serviceClassName; 
    @api orderHistoryPageName;
    @api orderData;
    showOrderDetail = false;
    totalOrderItem ;
    shippingAddress;
    showDeliveryStatus;
    webStoreId;
    isShowModal;
    updateCart;
    orderSummId;

    labels = {
        replaceCartItems
    };


    connectedCallback(){
        this.orderHistory = window.location.origin+communityPath+'/'+ this.orderHistoryPageName;
        this.isShowModal = false;
        this.updateCart = false;
        this.getOrderDetail(this.recordId);
    }

    //get my Order
    getOrderDetail(orderId) {
        var jsonString = JSON.stringify({
            orderId : orderId
        });
        getOrderDetails({ inputData : jsonString, serviceClassName : this.serviceClassName })
            .then((result) => {
                let response = JSON.parse(result);
                console.log('response--->'+JSON.stringify( response));
                if(response.isSuccess){
                    this.showOrderDetail = true;
                    this.orderData = response.orderData;
                    this.webStoreId = this.orderData.webStoreId;
                    this.shippingAddress = 'Ship to: ' +this.orderData.deliveryStreet + ', '+this.orderData.deliveryCity+', ' + this.orderData.deliveryState +' ' + this.orderData.deliveryPostalCode;
                    
                    this.totalOrderItem = this.orderData.orderItemList.length;
                    if(this.orderData.deliveryStatus == null){
                        this.showDeliveryStatus = false;
                    }else{
                        this.showDeliveryStatus = true;
                    }

                    for(const orderItem of this.orderData.orderItemList){
                        console.log('orderItemkey'+JSON.stringify(orderItem) );
                        if(orderItem.productImageURL.includes('/cms/')) {
                            orderItem.productImageURL = communityPath + '/sfsites/c' + orderItem.productImageURL;
                        }
                        console.log('orderItem.productImageURL---'+orderItem.productImageURL);
                    }  
                }
            })
            .catch((error) => {
                console.log("error :" + error);
            })
            .finally(() => (this.isLoading = false));
    }

    handleSectionToggle(event) {
        const openSections = event.detail.openSections;
        if (openSections.length === 0) {
            this.activeSectionsMessage = 'All sections are closed';
        } else {
            this.activeSectionsMessage =
                'Open sections: ' + openSections.join(', ');
        }
    }
    startReOrder(event){
        var orderSummaryid = event.target.dataset.summaryid;
        this.updateCart = true;
        this.reOrder(event);
    }

    reOrder(event){
        var orderSummaryid = event.target.dataset.summaryid;
        var jsonString = JSON.stringify({
            orderSummaryId : orderSummaryid,
            webStoreId : this.webStoreId,
            userId : this.userId,
            updateCart : this.updateCart
        });

        reOrder({ inputData: jsonString, serviceClassName : this.serviceClassName })
            .then((result) => {
                let response = JSON.parse(result);
                if(response.isSuccess){
                    let orderToCartResult = response.orderToCartResult;
                    window.location.href = window.location.origin+communityPath + '/cart';
                }else{
                    if(response.cartAlreadyExist){
                        this.isShowModal = true;
                    }
                }
            })
            .catch((error) => {
                console.log("error :" + error);
            })
            .finally(() => (this.isLoading = false));
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

    hideModalBox() {  
        this.isShowModal = false;
    }
}