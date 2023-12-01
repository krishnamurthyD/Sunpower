import { LightningElement } from 'lwc';
import SendProductCOde from '@salesforce/apex/WishlistController.getProductCode';
import toColorChange from '@salesforce/apex/WishlistController.CheckIfcodeProductisPresentOrNot'
import Id from '@salesforce/user/Id';


export default class WishlistButton extends LightningElement {
  userId = Id;
  colorChange=false;
  connectedCallback(){
    let url=window.location.href;
    let urlArray=url.split('/');
  let id=urlArray[urlArray.length-1];
  console.log(id);

  console.log('user id ='+this.userId );
  

  toColorChange({
    ProductIdFromJs:id,
    UserIdFromJs:this.userId
  })
  .then((data)=>{
    console.log(data);
    if(data == 'yes'){
      this.colorChange=true;
    }
  })
  .catch((error)=>{
    console.log(error);

  })

  }
  AddToWishListButtonHandler(){
    let url=window.location.href;
    let urlArray=url.split('/');
    let id=urlArray[urlArray.length-1];
    console.log(id);
  
    console.log('user id ='+this.userId );
  
    SendProductCOde({
      ProductIdFromJs:id,
      UserIdFromJs:this.userId
    })
    .then((data)=>{
      console.log(data);
      // Call the toColorChange function after SendProductCOde completes successfully
      return toColorChange({
        ProductIdFromJs:id,
        UserIdFromJs:this.userId
      });
    })
    .then((data)=>{
      console.log(data);
      if(data == 'yes'){
        this.colorChange=true;
      }
    })
    .catch((error)=>{
      console.log(error);
    });
  } 
}