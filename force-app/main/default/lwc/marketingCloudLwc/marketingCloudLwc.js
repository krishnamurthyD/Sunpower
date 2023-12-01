import { LightningElement,track } from 'lwc';
import sendEmail from '@salesforce/apex/MarketingCloudController.sendEmailViaMarketingCloud';
import LightningAlert from "lightning/alert";
//import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class MarketingCloudLwc extends LightningElement {
@track res;
sendEmailUsingMarketingCloud(){
const emailRegex=/^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
let email = this.template.querySelector('[data-id="txtEmailAddress"]');
let emailVal=email.value;
if(emailVal.match(emailRegex)){

  sendEmail({emailValue:emailVal})
      .then(result => {
          this.res=result;
         
  
          this.handleAlert();
              
      })
      .catch(error => {
          
          
      });

      email.setCustomValidity("");
      email.value="";
  

}else{
  email.setCustomValidity("Please enter valid email");
}
  email.reportValidity();
}

async handleAlert() {
  await LightningAlert.open({
    message: "Thank you for subscribing !",
    theme: "success",
    label: "Subscribed"
  }).then(() => {
    console.log("###Alert Closed");
  });
}

}