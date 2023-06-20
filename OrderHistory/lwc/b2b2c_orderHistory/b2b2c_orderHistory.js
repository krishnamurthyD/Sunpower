import { LightningElement,api } from 'lwc';
import USER_Id from '@salesforce/user/Id';
import getMyOrder from "@salesforce/apex/B2B2C_OrderHistory.getMyOrder";
import startReOrder from "@salesforce/apex/B2B2C_OrderHistory.startReOrder";
import communityPath from '@salesforce/community/basePath';

// Import custom labels
import replaceCartItems from "@salesforce/label/c.Replace_Cart_Item";

export default class OrderHistory extends LightningElement {
    value = 'Recent Orders';
    userId = USER_Id;
    isLoading = false;
    isOrderLoading = false;
    @api serviceClassName; 
    sortString = '';
    @api orderList = {};
    @api allOrderList = {};
    totalOrderCount;
    orderItemListTemp = [];
    @api allOrder;
    webStoreId;
    searchIconUrl;
    isShowModal;
    updateCart;
    orderSummId;

    labels = {
        replaceCartItems
    };

    get options() {
        return [
            { label: 'Recent Orders', value: 'PurchaseDateDESC' },
            { label: 'Oldest Orders', value: 'PurchaseDateASC' },
            { label: 'Order Number', value: 'ProductNameDESC' },
            { label: 'Order Total', value: 'OrderTotalDesc' },
        ];
    }

    connectedCallback(){
        this.isLoading = true;
        this.searchIconUrl = communityPath + '/assets/icons/utility-sprite/svg/symbols.svg#search';
        this.isShowModal = false;
        this.updateCart = false;
        this.getMyOrder();
    }

    handleChange(event) {
        this.value = event.target.value;
        this.sortString = this.value;
        this.getMyOrder();
    }


    //get my Order
    getMyOrder() {
        var jsonString = JSON.stringify({
            userId : this.userId,
            sortString : this.sortString
        });
        getMyOrder({ inputData: jsonString, serviceClassName : this.serviceClassName })
            .then((result) => {
                let response = JSON.parse(result);
                if(response.isSuccess){
                    this.orderList = response.orderHistoryModel;
                    this.totalOrderCount = this.orderList.length;
                    let orderListTemp = this.orderList;
                    this.isLoading = false;
                    for (const order of orderListTemp) {
                        console.log('order--->'+JSON.stringify(order));
                        console.log('order.orderId--->'+order.orderId);
                        order.orderDetailsUrl = window.location.origin+communityPath+'/order/'+order.orderId;
                        this.webStoreId = order.webStoreId;
                        for(const orderItem of order.orderItemList){
                            console.log('orderItemkey'+JSON.stringify(orderItem) );
                            this.orderItemListTemp.push(orderItem);
                            orderItem.productURL = window.location.origin+communityPath+'/product/'+orderItem.product2Id;
                            
                            if(orderItem.productImageURL.includes('/cms/')) {
                                orderItem.productImageURL = communityPath + '/sfsites/c' + orderItem.productImageURL;
                            }
                            console.log('orderItem.productImageURL---'+orderItem.productImageURL);
                        }  
                    }
                    this.allOrderList = response.orderHistoryModel;
                }else{
                    console.log("error :" + response.message);
                }
            })
            .catch((error) => {
                console.log("error :" + error);
            })
            .finally(() => (this.isLoading = false));
    }

    filterResult(e) {
        let PATTERN = e.target?.value;
        this.orderList  = this.allOrderList;
        this.orderList = this.orderList.filter(function (data) { return data.orderNumber.toLowerCase().includes(PATTERN.toLowerCase()) == true; });
        this.totalOrderCount = this.orderList.length;
    }
    startReOrder(event){
        var orderSummaryid = event.target.dataset.summaryid;
        this.updateCart = true;
        this.startOrder(event);
    }
    startOrder(event){
        var orderSummaryid = event.target.dataset.summaryid;
        this.orderSummId = orderSummaryid;
        var jsonString = JSON.stringify({
            orderSummaryId : orderSummaryid,
            webStoreId : this.webStoreId,
            userId : this.userId,
            updateCart : this.updateCart
        });

        startReOrder({ inputData: jsonString, serviceClassName : this.serviceClassName })
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
    hideModalBox() {  
        this.isShowModal = false;
    }
}