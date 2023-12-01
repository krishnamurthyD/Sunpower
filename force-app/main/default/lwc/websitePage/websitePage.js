import { LightningElement } from 'lwc';
import food1 from '@salesforce/resourceUrl/food1';
import food2 from '@salesforce/resourceUrl/food2';
import food3 from '@salesforce/resourceUrl/food3';
import about from '@salesforce/resourceUrl/about';
import menu1 from '@salesforce/resourceUrl/menu1';
import menu2 from '@salesforce/resourceUrl/menu2';
import menu3 from '@salesforce/resourceUrl/menu3';
import menu4 from '@salesforce/resourceUrl/menu4';
import menu5 from '@salesforce/resourceUrl/menu5';
import menu6 from '@salesforce/resourceUrl/menu6';
import male1 from '@salesforce/resourceUrl/male1';
import male2 from '@salesforce/resourceUrl/male2';
import male3 from '@salesforce/resourceUrl/male3';

export default class WebsitePage extends LightningElement {
    male1Image = male1;
    male2Image = male2;
    male3Image = male3;

    menu1Image = menu1;
    menu2Image = menu2;
    menu3Image = menu3;
    menu4Image = menu4;
    menu5Image = menu5;
    menu6Image = menu6;

    aboutImage = about;
    food1Image = food1;
    food2Image = food2;
    food3Image = food3;

    // $(document).ready(function(){
    //     // Add smooth scrolling to all links
    //     $("a").on('click', function(event) {

    //         // Make sure this.hash has a value before overriding default behavior
    //         if (this.hash !== "") {
    //         // Prevent default anchor click behavior
    //         event.preventDefault();

    //         // Store hash
    //         var hash = this.hash;

    //         // Using jQuery's animate() method to add smooth page scroll
    //         // The optional number (800) specifies the number of milliseconds it takes to scroll to the specified area
    //         $('html, body').animate({
    //             scrollTop: $(hash).offset().top
    //         }, 800, function(){

    //             // Add hash (#) to URL when done scrolling (default click behavior)
    //             window.location.hash = hash;
    //         });
    //         } // End if
    //     });
    //     });
}