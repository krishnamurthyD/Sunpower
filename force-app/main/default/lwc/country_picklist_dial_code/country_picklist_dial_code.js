import { LightningElement, track, wire } from 'lwc';
// import { loadScript, loadStyle } from 'lightning/platformResourceLoader';
import jqueryResource from '@salesforce/resourceUrl/countrAndPhoneCode';
import JQUERY from '@salesforce/resourceUrl/JqueryPackage';

import {loadStyle,loadScript} from 'lightning/platformResourceLoader';


export default class CountryDropdown extends LightningElement {
  connectedCallback (){
    Promise.all([  
      loadScript(this,jqueryResource)
      ]).
      then(()=>{
        alert('successfull');
      }).catch((error=>{
      alert('Load Failed');
      }))
    }
}
//   @track countryOptions = [];
//   @track selectedCountry = '';
//   @track selectedCountryCode = '';
//   jqueryone=jqueryResource;

// renderedCallback(){
//     JSON.parse(JSON.stringify(jqueryResource))
//     console.log(JSON.parse(JSON.stringify(jqueryResource)));
//     // loadScript(this,jqueryResource).then((data)=>{
//     //     console.log('onedayimgoing'+data);
//     // }).catch((error)=>{
//     //     console.log('onedayimgoing'+error);
//     // })
// }

  // connectedCallback() {

  //   countryOptions = [];

 // connectedCallback() {
  //   fetch(jqueryResource)
  //     .then((response) => response.json())
  //     .then((data) => {
  //       this.processCountryData('onedayimgoing'+data);
  //     })
  //     .catch((error) => {
  //       console.error('Error fetching country data:', error);
  //     });
  // }

//   processCountryData(data) {
//     console.log('onedayimgoing'+data);
//     // Extract country name and phone code from the JSON data
//     const options = data.map((country) => ({
//       label: country.name,
//       value: country.phoneCode
//     }));

//     // Set the picklist options
//     this.countryOptions = options;
//     console.log('onedayimgoing'+ this.countryOptions);
//   }

  //   Promise.all([
  //     loadScript(this, jqueryResource +'/.js')
  //   ]).then((data) => {
  //       console.log('happybirthday data'+data);
  //       console.log('jqueryone'+loadScript(this, jqueryResource +'/.js'));
  //     this.loadCountryData();
  //   }).catch(error => {
  //     // Handle error
  //     console.log('happybirthday error'+error);
  //   });
  // }

//   loadCountryData() {
//     // Perform logic to load country data from the jQuery file in the static resource
//     // Example:
//     // $.getJSON('/resource/jquery/countryData.json', (data) => {
//     //   this.countryOptions = data;
//     // }).fail((jqxhr, textStatus, error) => {
//     //   // Handle error
//     // });
//   }

//   handleCountryChange(event) {
//     this.selectedCountry = event.target.value;
//     this.selectedCountryCode = event.target.value;
//   }

