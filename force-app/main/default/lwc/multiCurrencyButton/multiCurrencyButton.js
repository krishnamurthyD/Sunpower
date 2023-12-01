import { LightningElement, track, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import CURRENCY_FIELD from '@salesforce/schema/PriceBook2.CurrencyIsoCode';
import multiCurrencyProductone from '@salesforce/apex/multiCurrencyController.getProductPrices';


export default class MultiCurrencyButton extends LightningElement {

  @track selectedCurrency='USD' ;
  currencyOptions = [
    { label: 'GBP (£)', value: 'GBP' },
    { label: 'USD ($)', value: 'USD' },
    { label: 'EUR (€)', value: 'EUR' }
  ];

  @wire(getRecord, {
    recordId: 'YOUR_PRICE_BOOK_RECORD_ID',
    fields: [CURRENCY_FIELD]
  })
  priceBook;

  handleCurrencyChange(event) {
    this.selectedCurrency = event.detail.value;
    let url=window.location.href;
    let urlArray=url.split('/');
    let id=urlArray[urlArray.length-1];
    console.log(id);
    multiCurrencyProductone({
      productIdFromWebsite:id,
      CurrencyIsoCodeFromWebsite:this.selectedCurrency
    })
    .then((data)=>{
        console.log(data);
    })
    .catch((error)=>{
        console.log(error);
    })
  }

  get priceBookCurrency() {
    return getFieldValue(this.priceBook.data, CURRENCY_FIELD);
  }

  get isCurrencyMatch() {
    return this.priceBookCurrency === this.selectedCurrency;
  }
}