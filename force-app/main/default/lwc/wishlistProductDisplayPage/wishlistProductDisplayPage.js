import { LightningElement,track } from 'lwc';
import getWishlistProductList from '@salesforce/apex/WishlistProductsFetching.sendProductList';
import DeleteTheProduct from '@salesforce/apex/WishlistProductsFetching.DeleteTheWishlistProduct';
import AddTheWishlistProductToCart from '@salesforce/apex/WishlistProductsFetching.AddtheProductToWishlist';
import bootStrap from '@salesforce/resourceUrl/Bootstrap';
import {loadStyle,loadScript} from 'lightning/platformResourceLoader';
import Id from '@salesforce/user/Id';


export default class WishlistProductDisplayPage extends LightningElement {
    @track result =[];
    userId = Id;
    dataFromWishlist;
    @track currentImage;
    @track wantedString;
    wishlistItemToBeDeleted;
    @track productIdToBeAddedIntoCatr
    ProductsAndThereWIshlistID= new Map();
    DeleteTheProductAfterAddingTOTheCart;

    completeImage;

    renderedCallback(){
        Promise.all([
            loadScript(this,bootStrap +'/bootstrap-5.0.2-dist/js/bootstrap.js'),
          
           // loadScript(this,jQuery),
            loadStyle(this,bootStrap +'/bootstrap-5.0.2-dist/css/bootstrap.min.css')
        ]).then(()=>{
            console.log('loaded');
        })
        }

    connectedCallback(){
        getWishlistProductList({UserIdFromJs:this.userId})
    .then((data)=>{
        console.log(data);
        data.forEach(element=>{
            this.ProductsAndThereWIshlistID.set(element.productSummary.productId ,element.wishlistItemId);
        })
        data.forEach(element => {
           this.currentImage = element.productSummary.thumbnailImage.url;
           this.wantedString='https://'
            if(this.currentImage.includes(this.wantedString))
            {
                console.log(this.currentImage);
            }else{
                this.currentImage = 'https://tavant-c6-dev-ed.lightning.force.com'+this.currentImage;
                element.productSummary.thumbnailImage.url=this.currentImage;
                console.log(this.currentImage);
            }  
        });
        this.dataFromWishlist=data;
        
    })
    .catch((error)=>{
        console.log(error);
    })
    }
    DeleteHandler(event){
        this.wishlistItemToBeDeleted=event.target.value;
        console.log(this.wishlistItemToBeDeleted);
        DeleteTheProduct({
            ProductWishlistItemId:this.wishlistItemToBeDeleted,
            UserIdFromJs:this.userId
        }).then((data)=>{
            console.log(data);
            location.reload();

        }).catch((error)=>{
            console.log(error);
        })
    }
    AddTocartHandler(event){
        this.productIdToBeAddedIntoCatr=event.target.value
        console.log(this.productIdToBeAddedIntoCatr);
        this.DeleteTheProductAfterAddingTOTheCart=this.ProductsAndThereWIshlistID.get(this.productIdToBeAddedIntoCatr);
        console.log(this.DeleteTheProductAfterAddingTOTheCart);

        AddTheWishlistProductToCart({
            ProductIdToBeaddedToAddToCart:this.productIdToBeAddedIntoCatr,
            UserIdFromJs:this.userId
        }).then((data)=>{
            console.log(data);
          return DeleteTheProduct({
              ProductWishlistItemId:this.DeleteTheProductAfterAddingTOTheCart,
              UserIdFromJs:this.userId
          }).then((data)=>{
              console.log(data);
              location.reload();
  
          })

        }).catch((error)=>{
            console.log(error);
        })

    }
}