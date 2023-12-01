import { LightningElement } from 'lwc';
import { loadStyle, loadScript } from 'lightning/platformResourceLoader';
import slickSlider from '@salesforce/resourceUrl/slickSliderFile';
import bootStrap from '@salesforce/resourceUrl/Bootstrap';
import kgf from '@salesforce/resourceUrl/KGF';
import ImageOne from '@salesforce/resourceUrl/ImageOne';

export default class CaroselForTopManufacturer extends LightningElement {
    KgfImg=kgf;
    ImageOneImage=ImageOne;
  connectedCallback() {
    Promise.all([
      loadStyle(this, slickSlider + '/slick-1.8.1/slick/slick.css'),
      loadStyle(this, slickSlider + '/slick-1.8.1/slick/slick-theme.css'),
      loadScript(this, slickSlider + '/slick-1.8.1/slick/slick.min.js')
    ]).then((data) => {
      console.log('rrrrrrrrrrrrrrrrrrrrrrrrr'+data);
      this.initializeSlider();
    });
  }
  renderedCallback(){
    Promise.all([
        loadScript(this,bootStrap +'/bootstrap-5.0.2-dist/js/bootstrap.js'),
       // loadScript(this,jQuery),
        loadStyle(this,bootStrap +'/bootstrap-5.0.2-dist/css/bootstrap.min.css')
    ]).then(()=>{
        console.log('loaded');
    })
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
       autoplaySpeed:2000
      });
    }
  }


 // document.querySelector('[data-component-id="navigationMenu-6830"]').querySelector("li:first-child").addEventListener("click",function(event){alert("you clicked it")});