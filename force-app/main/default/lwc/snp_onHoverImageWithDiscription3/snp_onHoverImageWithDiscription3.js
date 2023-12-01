/**
 * @description          On Hover Image With Discription #tiles
 * @Author               Krishnamurthy Donta
 * @Createddate          19-06-2023
 * @ControllerClass      
 * @TestClass            
 * @modificationSummary  Nameofmodifier - modification date - modifications made
 */

import { LightningElement } from 'lwc';
import imageThreeHoverWithDiscription from '@salesforce/resourceUrl/imageThreeHoverWithDiscription';
import imageTwoHoverWithDiscription from '@salesforce/resourceUrl/imageTwoHoverWithDiscription';
import imageOneHoverWithDiscription from '@salesforce/resourceUrl/imageOneHoverWithDiscription';

export default class Snp_onHoverImageWithDiscription3 extends LightningElement {
    imageThreeHoverWithDiscription3 = imageThreeHoverWithDiscription;
    imageTwoHoverWithDiscription2 = imageTwoHoverWithDiscription
    imageOneHoverWithDiscription1 =imageOneHoverWithDiscription

    FirstImage = true;
    SecondImage = false;
    ThirdImage = false


    handelFirstImage(){
   this.FirstImage = true;
    this.SecondImage = false;
    this.ThirdImage = false;
    }
    
    handelSecondImage(){
        this.FirstImage = false;
        this.SecondImage = true;
        this.ThirdImage = false;
    }

    handelThirdImage(){
    this.FirstImage = false;
    this.SecondImage = false;
    this.ThirdImage = true;
    }
    

}