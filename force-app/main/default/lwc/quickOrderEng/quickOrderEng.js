import { LightningElement,track,wire } from 'lwc';
import AddToCart from '@salesforce/apex/AddToCartController.matchProducts';
import Id from '@salesforce/user/Id';


export default class QuickOrderEng extends LightningElement {
    URL = window.location.href;
    AddTheRow=0;
    keyId=4;
    @track data = [];
    skueCodeStorer=[];
    skuCodeReader="";
    // list;
    numbertoRecognice=0;
    resultFromApex;
    accountId;
    userId = Id;


    wiredUser({ error, data }) {
        if (data) {
            this.accountId = data;
            console.log(data);
            console.log(data.fields);
            console.log(data.fields.id)
            console.log(this.userId);
            //getFieldValue(data, USER_ACCOUNT_FIELD);
        } else if (error) {
            console.error(error);
        }
    }
   
    
     AddOneMoreRow(){
        let obj={
            Sku_code:"",
            quantity:"25",
            id: ++this.keyId
        }
        this.data=[...this.data, Object.create(obj)];
        console.log(this.data);
    }
    HandelAndStoreTheValue(event){
        this.skuCodeReader=event.target.value;
        console.log(this.skuCodeReader);
        this.skueCodeStorer.push(this.skuCodeReader);
        console.log(this.skueCodeStorer);
    }
    AddToCart(){
        console.log("Im getting");
        console.log(this.skueCodeStorer);
        console.log(this.userId);

       // this.list=this.skueCodeStorer.join(', ')
        // console.log(this.list);
        AddToCart({SkuId :this.skueCodeStorer,userId : this.userId})
        .then(result=>{
            this.resultFromApex=result
            window.location.href = 'https://lwc10110-dev-ed.my.site.com/parkelectricalservicesdemo/cart';
            console.log(this.resultFromApex);
        })
        .catch(error=>{
            console.log(error);
        })
    }
}