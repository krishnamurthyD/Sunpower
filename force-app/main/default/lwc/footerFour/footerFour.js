import { LightningElement,track } from 'lwc';
import bootStrap from '@salesforce/resourceUrl/bootstrap';
//import jQuery from '@salesforce/resourceUrl/jquery';
import {loadStyle,loadScript} from 'lightning/platformResourceLoader';
import image from '@salesforce/resourceUrl/CloudodysseyNew';
import GrayesthLogo from '@salesforce/resourceUrl/ImageOfLogo';
import linkdin from '@salesforce/resourceUrl/linkdin';
import Twitter from '@salesforce/resourceUrl/Twitter';
import YouTube from '@salesforce/resourceUrl/YouTube';
import Instagram from '@salesforce/resourceUrl/Instagram';
import smegLogo from '@salesforce/resourceUrl/smegLogo';

//	smegLogo
import sendEmail from '@salesforce/apex/MarketingCloudController.sendEmailViaMarketingCloud';
import LightningAlert from "lightning/alert";

export default class FooterFour extends LightningElement {
    
    imageFromStaticResourcr=image;
    imageBelowThebuttons=GrayesthLogo;
    imageOfLinkdin=linkdin;
    imageOfTwitter=Twitter;
    imagewOfYouTube=YouTube;
    imageOfInstagram=Instagram;
    imageOfsmegLogo=smegLogo;
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
    renderedCallback(){
        Promise.all([
            loadScript(this,bootStrap +'/bootstrap-5.1.3-dist/js/bootstrap.js'),
           // loadScript(this,jQuery),
            loadStyle(this,bootStrap +'/bootstrap-5.1.3-dist/css/bootstrap.min.css')
        ]).then(()=>{
            console.log('loaded');
        })
        }
        
    
    }