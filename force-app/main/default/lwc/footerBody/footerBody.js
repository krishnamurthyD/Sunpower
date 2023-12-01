import { LightningElement,track } from 'lwc';
import CompanyLogo from '@salesforce/resourceUrl/logo2';
// import Instagram from '@salesforce/resourceUrl/Instagram'
import Instagram from '@salesforce/resourceUrl/InstagramBlack'
import facebook from '@salesforce/resourceUrl/facebook'
// import Twitter from '@salesforce/resourceUrl/Twitter'
import Twitter from '@salesforce/resourceUrl/TwitterBlack'
import EuropianUnion from '@salesforce/resourceUrl/EuropianUnion'
import UVDB from '@salesforce/resourceUrl/UVDB'
import BSI from '@salesforce/resourceUrl/BSI'
import Siemens from '@salesforce/resourceUrl/Siemens'
import Achilles from '@salesforce/resourceUrl/Achilles'
import Visa from '@salesforce/resourceUrl/Visa'
import VisaDebit from '@salesforce/resourceUrl/VisaDebit'
import MasterCard from '@salesforce/resourceUrl/MasterCard'
import maestro from '@salesforce/resourceUrl/maestro'
import Paypal from '@salesforce/resourceUrl/Paypal'
import Gpay from '@salesforce/resourceUrl/Gpay'
import PowerBy from '@salesforce/resourceUrl/PowerBy'
import sendEmail from '@salesforce/apex/MarketingCloudController.sendEmailViaMarketingCloud';
import LightningAlert from "lightning/alert";


export default class FooterBody extends LightningElement {
    companyLogo = CompanyLogo;
    InstagramImg = Instagram;
    facebookImg = facebook;
    TwitterImg = Twitter;
    EuropianUnionImg = EuropianUnion;
    UVDBImg = UVDB;
    BSIImg = BSI;
    SiemensImg = Siemens;
    AchillesImg = Achilles;
    VisaImg = Visa;
    VisaDebitImg = VisaDebit;
    MasterCardImg = MasterCard;
    maestroImg = maestro;
    PaypalImg = Paypal;
    GpayImg = Gpay;
    PowerByImg = PowerBy;

    @track res;
sendEmailUsingMarketingCloud(){
const emailRegex=/^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
let email = this.template.querySelector('[data-id="txtEmailAddress"]');
let emailVal=email.value.trim();
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