import { LightningElement } from 'lwc';
import { loadStyle, loadScript } from 'lightning/platformResourceLoader';
import AppleImage from '@salesforce/resourceUrl/AppleImage';
import Oranger from '@salesforce/resourceUrl/Oranger';
import futura from '@salesforce/resourceUrl/futura';


export default class HTMLCSSPractice extends LightningElement {
    
    AppleImageFrom=AppleImage;
    OrangerImages=Oranger;

    connectedCallback() {
        Promise.all([
          loadStyle(this, futura + '/resource/futura/Futura Heavy font.ttf'),    
        ]).then(() => {
          this.initializeSlider();
        });
      }
}