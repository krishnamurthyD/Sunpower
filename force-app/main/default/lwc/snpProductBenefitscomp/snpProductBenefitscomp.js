import { LightningElement,wire,track } from 'lwc';
import getProductSections from '@salesforce/apex/ManagedContentController.getProductSections';
import PDPlabel from '@salesforce/label/c.PDP_label';
export default class SnpProductBenefitscomp extends LightningElement {
  filteredsections;
 dynamicfilteredsections;
  currentopensectionindex="0";
  sectionid;
  mobwidth;
  showmobview;
  showdesktopview;
  mobprevsec="0";
  mobsectionid;
  url=window.location.href;
  spliturl=this.url.split('/');
  product=this.spliturl[this.spliturl.length-1];
  productid=this.product.substring(0,18);
  productBenifitsDisplay = true;

  @track imageUrl;

  connectedCallback(){
    getProductSections({ productid: this.productid })
      .then((result) => {
        console.log('**apexgetProductSections*'+JSON.stringify(result));
        console.log('**apexgetProductSections*'+Object.keys(result).length);
       this.dynamicfilteredsections = result.filter(section => Object.keys(section).length > 1);
       console.log('**this.dynamicfilteredsections*'+JSON.stringify(this.dynamicfilteredsections));
       this.filteredsections = this.dynamicfilteredsections.map(item =>({ id: item.id,
        'verticalHeading':item.verticalHeading,
        'horizontalHeading':item.horizontalHeading,
      'description':item.description,
      'image':item.image,
      'contentKey' :PDPlabel + item.contentKey}));
      console.log('**filteredSections*'+JSON.stringify(this.filteredsections));

        // this.showDivs = true;
        // debugger;
        // this.imageUrl='data:image/png;base64,'+this.filteredsections[0].image;
        /*var image = document.createElement("img");
        var s = 'data:image/jpeg;base64,'+this.filteredsections[0].image;
        console.log('Image'+this.filteredsections[0].image);
        console.log('S val'+s);
        image.setAttribute("src",s);
        this.template.querySelector('.jubesh').appendChild(image);*/
      })
      .catch((error) => {
        console.log('***'+JSON.stringify(error));
      });

  }
  renderedCallback(){
    this.mobwidth=window.innerWidth;
    if(this.mobwidth<992){
      
      this.showmobview=true;
    }
    if(this.mobwidth<992){
      if(this.template.querySelector('.mob-section')){
        this.mobilefuntion();
      }
    }else{
      if(this.template.querySelector('.product-benifit-section-outer')){
        this.desktopFunction();
      }

    }
    console.log("current inner width",this.filteredsections);
    if(this.filteredsections?.length === 0){
      this.productBenifitsDisplay = false;
    }

  }

  desktopFunction(){
    debugger;
    for(let i = 0; i < this.filteredsections.length; i++){
      const sectionid=i;
      console.log('^^^^'+i);
      const horizontal = this.template.querySelector('.product-benifit-section-outer[data-section-id='+ '"'+i+'"' +']');
      const vertical = this.template.querySelector('.pb-closed-section-outer[data-section-id='+ '"'+i+'"' +']');
      console.log('horizontal'+JSON.stringify(horizontal));
      horizontal.classList.add('hidden');
      const myclass = 'class'+i;
      horizontal.classList.add(myclass);
      vertical.classList.add(myclass);
      if(this.filteredsections.length==3){
       horizontal.classList.add('widthclass1');
       vertical.classList.add('widthclass1');
      }
      else if(this.filteredsections.length==2){
        horizontal.classList.add('widthclass2');
        vertical.classList.add('widthclass2');
      }
      else if(this.filteredsections.length==4){
        horizontal.classList.add('widthclass3');
        vertical.classList.add('widthclass3');
      }
      else if(this.filteredsections.length==1){
        horizontal.classList.add('full-width');
        vertical.classList.add('widthclass3');
      }
      else{
        horizontal.classList.add('widthclass4');
        vertical.classList.add('widthclass4');
      }
  }
   const vertical = this.template.querySelector('.pb-closed-section-outer[data-section-id="0"]');
   const horizontal = this.template.querySelector('.product-benifit-section-outer[data-section-id="0"]');
    vertical.classList.add('hidden');
    horizontal.classList.remove('hidden');
}
mobilefuntion(){
  debugger;
  for(let i = 0; i < this.filteredsections.length; i++){
    //const sectionid=i;
    //console.log('^^^^'+i);
    const button = this.template.querySelector('.tabitem[data-section-id='+ '"'+i+'"' +']');
    const card = this.template.querySelector('.mob-section[data-section-id='+ '"'+i+'"' +']');
    console.log('mobhorizontal'+JSON.stringify(card));
    const myclass = 'mobclass'+i; 
    card.classList.add('mobhidden');
    button.classList.add(myclass);
    card.classList.add(myclass);
}
   const card = this.template.querySelector('.mob-section[data-section-id="0"]');
   card.classList.remove('mobhidden');
}

closedSectionMouseEnterHandle(event){
  debugger;
  this.sectionid = event.currentTarget.dataset.sectionId;
  console.log('&&&'+this.sectionid);
    const vertical = this.template.querySelector(`.pb-closed-section-outer[data-section-id="${this.sectionid}"]`);
    const horizontal = this.template.querySelector(`.product-benifit-section-outer[data-section-id="${this.sectionid}"]`);
    const verticalprev = this.template.querySelector(`.pb-closed-section-outer[data-section-id="${this.currentopensectionindex}"]`);
    const horizontalprev = this.template.querySelector(`.product-benifit-section-outer[data-section-id="${this.currentopensectionindex}"]`);

    if(this.sectionid>this.currentopensectionindex){
      for(let i = this.currentopensectionindex; i < this.sectionid; i++){
        const vertical = this.template.querySelector('.pb-closed-section-outer[data-section-id='+ '"'+i+'"' +']');
        console.log('horizontal'+JSON.stringify(horizontal));
        vertical.classList.add('verticaltranslate');
        horizontalprev.classList.add('verticaltranslate');
      }
    }else{
      for(let i = this.sectionid; i <this.filteredsections.length; i++){
        const vertical = this.template.querySelector('.pb-closed-section-outer[data-section-id='+ '"'+i+'"' +']');
        console.log('horizontal'+JSON.stringify(horizontal));
        vertical.classList.remove('verticaltranslate');
        vertical.previousElementSibling.classList.remove('verticaltranslate');
      }
    }

      vertical.classList.add('hidden');

   horizontal.classList.remove('hidden');
    verticalprev.classList.remove('hidden');
    //horizontalprev.classList.add('hidden');
   // this.currentopensectionindex=this.sectionid;
    this.currentopensectionindex=this.sectionid;
}

mobbuttonhandler(event){
  this.mobsectionid = event.currentTarget.dataset.sectionId;
  console.log('&&&'+this.mobsectionid);
    const prevcard = this.template.querySelector(`.mob-section[data-section-id="${this.mobprevsec}"]`);
    const card = this.template.querySelector(`.mob-section[data-section-id="${this.mobsectionid}"]`);
    
    prevcard.classList.add('mobhidden');
    card.classList.remove('mobhidden');
   // this.currentopensectionindex=this.sectionid;
    this.mobprevsec=this.mobsectionid;

}
    
    


    card1collapsedhandler(){
        const element1=this.template.querySelector('.card1-style-0').classList;
        const element2=this.template.querySelector('.card1-collapsed-card-outer').classList;
        const element3=this.template.querySelector('.card2-style-0').classList;
        const element4=this.template.querySelector('.card2-collapsed-card-outer').classList;
        const element5=this.template.querySelector('.card3-style-0').classList;
        const element6=this.template.querySelector('.card3-collapsed-card-outer').classList;

         element1.add("card100");
         element2.add("card99");
         element3.add("card99");
         element4.add("card100");
         element4.remove("card101");
        element5.remove("card100");
        element6.remove("card99");
     
        
    }
    card2collapsedhandler(){
        console.log('**start**')
        const element7=this.template.querySelector('.card1-style-0').classList;
        const element8=this.template.querySelector('.card1-collapsed-card-outer').classList;
        const element9=this.template.querySelector('.card2-style-0').classList;
        const element10=this.template.querySelector('.card2-collapsed-card-outer').classList;
        const element11=this.template.querySelector('.card3-style-0').classList;
        const element12=this.template.querySelector('.card3-collapsed-card-outer').classList;
        console.log(element7);

         element7.remove("card100");
         element8.remove("card99");
         element8.add("card101");
         element9.remove("card99");
         element10.remove("card100");
         element11.remove("card100");
        element12.remove("card99");
       
    }
    card3collapsedhandler(){
        const element7=this.template.querySelector('.card1-style-0').classList;
        const element8=this.template.querySelector('.card1-collapsed-card-outer').classList;
        const element9=this.template.querySelector('.card2-style-0').classList;
        const element10=this.template.querySelector('.card2-collapsed-card-outer').classList;
        const element11=this.template.querySelector('.card3-style-0').classList;
        const element12=this.template.querySelector('.card3-collapsed-card-outer').classList;

        element9.add("card99");
        element10.add("card100");
        element10.add("card101");
        element11.add("card100");
        element12.add("card99");
    }
   //------new apporach-------------
   
  handleMouseOver(event) {
    const sectionid = event.currentTarget.dataset.sectionId;
    const verticalCard = this.template.querySelector(`.card.vertical[data-section-id="${sectionid}"]`);
    const horizontalCard = this.template.querySelector(`.card.horizontal[data-section-id="${sectionid}"]`);
    
    verticalCard.classList.remove('hidden');
    horizontalCard.classList.add('hidden');
    
        
  }

handleMouseOver1(event) {
  const sectionId = event.currentTarget.dataset.sectionId;
  const verticalCard = this.template.querySelector(`.card.vertical[data-section-id="${sectionId}"]`);
  const horizontalCard = this.template.querySelector(`.card.horizontal[data-section-id="${sectionId}"]`);
  
  console.log(horizontalCard);
  console.log(verticalCard);
      verticalCard.classList.add('hidden');
      horizontalCard.classList.remove('hidden');
  
}



 
}