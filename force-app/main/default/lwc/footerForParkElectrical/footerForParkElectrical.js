import { LightningElement} from 'lwc';
import bootStrap from '@salesforce/resourceUrl/bootstrap';
import {loadStyle,loadScript} from 'lightning/platformResourceLoader';
import image from '@salesforce/resourceUrl/CloudodysseyNew';
import GrayesthLogo from '@salesforce/resourceUrl/ImageOfLogo';
import linkdin from '@salesforce/resourceUrl/linkdin';
import Twitter from '@salesforce/resourceUrl/Twitter';
import YouTube from '@salesforce/resourceUrl/YouTube';
import Instagram from '@salesforce/resourceUrl/Instagram';
import smegLogo from '@salesforce/resourceUrl/smegLogo';

export default class FooterForParkElectrical extends LightningElement {
     
    imageFromStaticResourcr=image;
    imageBelowThebuttons=GrayesthLogo;
    imageOfLinkdin=linkdin;
    imageOfTwitter=Twitter;
    imagewOfYouTube=YouTube;
    imageOfInstagram=Instagram;
    imageOfsmegLogo=smegLogo;

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