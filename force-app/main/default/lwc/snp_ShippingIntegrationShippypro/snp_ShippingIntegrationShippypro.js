import { LightningElement ,wire} from 'lwc';
import getShippingRatesForCarriage from '@salesforce/apex/shippingIntegrationShippypro.getShippingRatesForCarriage';
import UserId from '@salesforce/user/Id';
import communityId from '@salesforce/community/Id';
import getCheckoutShippingAddressInformation from '@salesforce/apex/shippingIntegrationShippypro.getCheckoutShippingAddressInformation';

export default class Snp_ShippingIntegrationShippypro extends LightningElement {

  //From cartDeliveryGroup we will get the 
  //SELECT Id, DesiredDeliveryDate, DeliveryMethodId, DeliverToFirstName, DeliverToLastName, DeliverToName, DeliverToCity, DeliverToStreet, DeliverToState, DeliverToPostalCode, DeliverToCountry, DeliverToCountryCode, DeliverToStateCode, TotalProductAmount, DeliverToAddress, DeliverToLatitude, DeliverToLongitude, DeliverToGeocodeAccuracy, ShippingInstructions, IsDefault, TotalChargeAmount, TotalAmount FROM CartDeliveryGroup
  resultFromApexClass = 'hi';
  showPickList = false;
  selectedShipment = 'Select one shipment type';

  //get the currenyt checkout shipping address usig API call
  shippingRatesCheckout(){
    getCheckoutShippingAddressInformation({communityIdWTB:communityId})
    .then((result)=>{
      console.log('checkout call result------------------>',result);
    })
    .catch((error)=>{
      console.log('checkout call error------------------>',error);
    })
  }

 


  //show and hide the picklist
  shippingRates(){
      this.showPickList = !this.showPickList;
  }
  // on click call
  shippingRates(){
    console.log('Hi i clicked');
      if(this.showPickList){
        this.showPickList = false;
    }else{
    getShippingRatesForCarriage({userId:UserId})
    .then((result)=>{
    const jsonData= result;
    const parsedData = JSON.parse(jsonData);
    this.resultFromApexClass = parsedData.Rates;
    // this.resultFromApexClass = result;
    console.log('Shipping Integration One ---------------------->',result);
    console.log('Shipping Integration Three ---------------------->', this.resultFromApexClass);
    this.showPickList = true; 
    })
    .catch((error)=>{
    console.log('Shipping Integration---------------------->',error);
    })}
  }

  //Hide the picklist
  hidePicklist(event){
    let currentIndex = event.target.dataset.id;
    console.log('current list clicked', currentIndex);
    console.log(this.resultFromApexClass[currentIndex]);
    this.selectedShipment = event.target.innerText;
    this.showPickList= false;
    console.log(event.target.innerText);
  }
}