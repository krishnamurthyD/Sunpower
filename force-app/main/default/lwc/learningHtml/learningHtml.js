import { LightningElement } from 'lwc';
import { loadStyle, loadScript } from 'lightning/platformResourceLoader';
import bootStrap from '@salesforce/resourceUrl/Bootstrap';
import slickSlider from '@salesforce/resourceUrl/slickSliderFile';
import ImageOne from '@salesforce/resourceUrl/ImageOne';
import food1 from '@salesforce/resourceUrl/food1';
import food2 from '@salesforce/resourceUrl/food2';
import food3 from '@salesforce/resourceUrl/food3';
import ImageTwo from '@salesforce/resourceUrl/ImageTwo';
import ImageThree from '@salesforce/resourceUrl/ImageThree';


export default class LearningHtml extends LightningElement {
  food1Image=food1;
  food2Image=food2;
  food3Image=food3;
    ImageOneFromOrg=ImageOne;
    ImageTwoFromOrg=ImageTwo;
    ImageThreeFromOrg=ImageThree;

    renderedCallback(){
        Promise.all([
            loadScript(this,bootStrap +'/bootstrap-5.0.2-dist/js/bootstrap.js'),
           // loadScript(this,jQuery),
            loadStyle(this,bootStrap +'/bootstrap-5.0.2-dist/css/bootstrap.min.css')
        ]).then(()=>{
            console.log('loaded');
        })
        }

    connectedCallback() {
    Promise.all([
      loadStyle(this, slickSlider + '/slick-1.8.1/slick/slick.css'),
      loadStyle(this, slickSlider + '/slick-1.8.1/slick/slick-theme.css'),
      loadScript(this, slickSlider + '/slick-1.8.1/slick/slick.min.js')
    ]).then(() => {
      this.initializeSlider();
    });
  }
  initializeSlider() {
    const sliderElement = this.template.querySelector('.slider');
    $(sliderElement).slick({
      speed:200,
      infinite: true,
      slidesToShow: 3,
      slidesToScroll: 1,
      arrows:true,
      autoplay:true,
      autoplaySpeed:3000
    });
  }

}