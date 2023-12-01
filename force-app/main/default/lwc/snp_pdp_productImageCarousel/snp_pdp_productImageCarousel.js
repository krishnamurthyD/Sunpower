import { LightningElement, wire, api} from 'lwc';
import { loadStyle, loadScript } from 'lightning/platformResourceLoader';
import basePath from '@salesforce/community/basePath';
import slickSlider from '@salesforce/resourceUrl/slickSliderFile';
import getProductImages from '@salesforce/apex/Snp_pdp_productImageCorosoualController.getProductImages';
import upArrow from '@salesforce/resourceUrl/upArrow';
import downArrow from '@salesforce/resourceUrl/downArrow';
import communityId from '@salesforce/community/Id';

export default class Snp_pdp_productImageCarousel extends LightningElement {
    @api recordId;
    productId = '01t7R000008PNPpQAO';
    imgList = [];
    showCarousal = false;
    upArrow = upArrow;
    downArrow = downArrow;
    initialImageUrl = '';
    carousalSize = 0;
    currentSlideNumber = 0;
    communityId = communityId;

    connectedCallback() {
        console.log('recordId- ', this.productId);
        this.getProductData();
        Promise.all([
          loadStyle(this, slickSlider + '/slick-1.8.1/slick/slick.css'),
          loadStyle(this, slickSlider + '/slick-1.8.1/slick/slick-theme.css'),
          loadScript(this, slickSlider + '/slick-1.8.1/slick/slick.min.js')
        ]).then((data) => {
          console.log('Slick Loaded');
        //   this.initializeSlider();
        });
        this.showCarousal = true;
    }

    async getProductData() {
        await getProductImages({ ProductId: this.recordId, communityId: this.communityId })
            .then(result => {
                console.log('result- ', result);
                this.imgList = result.map(item => {
                    return {
                        url: basePath + '/sfsites/c' + item,
                    };
                });
                console.log('this.imgList- ', this.imgList);
                this.initialImageUrl = this.imgList[0].url;
                this.carousalSize = this.imgList.length;
                console.log('this.carousalSize- ', this.carousalSize);
                if(this.carousalSize <= 5){
                    if(this.carousalSize < 2){
                        this.template.querySelector('.left-arrow-image').classList.add('button-visiblity');
                        this.template.querySelector('.right-arrow-image').classList.add('button-visiblity');
                    }
                    this.template.querySelector('.up-arrow-image').classList.add('button-visiblity');
                    this.template.querySelector('.down-arrow-image').classList.add('button-visiblity');
                }
            })
            .catch(error => {
                console.log('Error- ', error);
            });
        this.initializeSlider();
    }

    initializeSlider(){
        const sliderElement = this.template.querySelector('.slider');
        $(sliderElement).slick({
            dots: false,
            arrows:true,
            vertical: true,
            slidesToShow: 5,
            slidesToScroll: 1,
            autoplay: false,
            infinite: false,
            centerMode:true,
            responsive:[
                {
                    breakpoint: 768,
                    settings: {
                        infinite: true,
                        swipeToSlide: true
                    }
                }
            ]   
            
        });
    }
    handleUp(){
        if(this.currentSlideNumber > 0){
            this.currentSlideNumber = this.currentSlideNumber - 1;
            // this.handleDisableButtonClass();
        }

        console.log('this.currentSlideNumber- ', this.currentSlideNumber);
        this.template.querySelector('.slick-prev').click();
        this.template.querySelector('.hero-img').src=this.template.querySelector('.slick-current > img').getAttribute("src");
    }

    handleDown(){
        // debugger;
        if(this.currentSlideNumber < this.carousalSize - 1){
            this.currentSlideNumber = parseInt(this.currentSlideNumber) + 1;
            // this.handleDisableButtonClass();
        }
        console.log('this.currentSlideNumber- ', this.currentSlideNumber);
        // this.handleDisableButtonClass();
        
        this.template.querySelector('.slick-next').click();
        this.template.querySelector('.hero-img').src=this.template.querySelector('.slick-current > img').getAttribute("src");
        console.log('Button clicked Successfully.');
    }

    handleDisableButtonClass(){
        // debugger;
        if(this.currentSlideNumber == 0){
            this.template.querySelector('.up-arrow-image').classList.contains('disable-button') ? '' : this.template.querySelector('.up-arrow-image').classList.add('disable-button');
            this.template.querySelector('.left-arrow-image').classList.contains('disable-button') ? '' : this.template.querySelector('.left-arrow-image').classList.add('disable-button');
            this.template.querySelector('.down-arrow-image').classList.contains('disable-button') ? this.template.querySelector('.down-arrow-image').classList.remove('disable-button') : '';
            this.template.querySelector('.right-arrow-image').classList.contains('disable-button') ? this.template.querySelector('.right-arrow-image').classList.remove('disable-button') :  '';
        }else if(this.currentSlideNumber == this.carousalSize - 1){
            this.template.querySelector('.up-arrow-image').classList.contains('disable-button') ? this.template.querySelector('.up-arrow-image').classList.remove('disable-button') : '';
            this.template.querySelector('.left-arrow-image').classList.contains('disable-button') ? this.template.querySelector('.left-arrow-image').classList.remove('disable-button') : '';
            this.template.querySelector('.down-arrow-image').classList.contains('disable-button') ? '' : this.template.querySelector('.down-arrow-image').classList.add('disable-button');
            this.template.querySelector('.right-arrow-image').classList.contains('disable-button') ? '' : this.template.querySelector('.right-arrow-image').classList.add('disable-button');
        }else{
            this.template.querySelector('.up-arrow-image').classList.contains('disable-button') ? this.template.querySelector('.up-arrow-image').classList.remove('disable-button') : '';
            this.template.querySelector('.left-arrow-image').classList.contains('disable-button') ? this.template.querySelector('.left-arrow-image').classList.remove('disable-button') : '';
            this.template.querySelector('.down-arrow-image').classList.contains('disable-button') ? this.template.querySelector('.down-arrow-image').classList.remove('disable-button') : '';
            this.template.querySelector('.right-arrow-image').classList.contains('disable-button') ? this.template.querySelector('.right-arrow-image').classList.remove('disable-button') : '';
        }
    }

    handleThumbnailClicked(event){
        // debugger;
        var currentImage = event.currentTarget.dataset.id;
        this.currentSlideNumber = currentImage
        console.log('currentImage- ', currentImage);
        this.template.querySelector('.hero-img').src = this.imgList[currentImage].url;

        var allImageSlid = this.template.querySelectorAll('.slick-slide');
        // console.log("allImage",allImageSlid,event.currentTarget,event.currentTarget.classList.add("one"));
        allImageSlid.forEach(item => {
            if(item !== event.currentTarget) {
                item.classList.remove("slick-current");
                console.log("ok");
            } else {
                item.classList.add("slick-current");
                console.log("no");
            }
        });
        // this.handleThumbnailClickedButtonClass(currentImage);
    }

    handleThumbnailClickedButtonClass(e){
        console.log(e);
        if(e == 0){
            this.template.querySelector('.up-arrow-image').classList.contains('disable-button') ? '' : this.template.querySelector('.up-arrow-image').classList.add('disable-button');
            this.template.querySelector('.left-arrow-image').classList.contains('disable-button') ? '' : this.template.querySelector('.left-arrow-image').classList.add('disable-button');
            this.template.querySelector('.down-arrow-image').classList.contains('disable-button') ? this.template.querySelector('.down-arrow-image').classList.remove('disable-button') : '';
            this.template.querySelector('.right-arrow-image').classList.contains('disable-button') ? this.template.querySelector('.right-arrow-image').classList.remove('disable-button') :  '';
        }else if(e == this.carousalSize - 1){
            this.template.querySelector('.up-arrow-image').classList.contains('disable-button') ? this.template.querySelector('.up-arrow-image').classList.remove('disable-button') : '';
            this.template.querySelector('.left-arrow-image').classList.contains('disable-button') ? this.template.querySelector('.left-arrow-image').classList.remove('disable-button') : '';
            this.template.querySelector('.down-arrow-image').classList.contains('disable-button') ? '' : this.template.querySelector('.down-arrow-image').classList.add('disable-button');
            this.template.querySelector('.right-arrow-image').classList.contains('disable-button') ? '' : this.template.querySelector('.right-arrow-image').classList.add('disable-button');
        }else{
            this.template.querySelector('.up-arrow-image').classList.contains('disable-button') ? this.template.querySelector('.up-arrow-image').classList.remove('disable-button') : '';
            this.template.querySelector('.left-arrow-image').classList.contains('disable-button') ? this.template.querySelector('.left-arrow-image').classList.remove('disable-button') : '';
            this.template.querySelector('.down-arrow-image').classList.contains('disable-button') ? this.template.querySelector('.down-arrow-image').classList.remove('disable-button') : '';
            this.template.querySelector('.right-arrow-image').classList.contains('disable-button') ? this.template.querySelector('.right-arrow-image').classList.remove('disable-button') : '';
        }
    }
}