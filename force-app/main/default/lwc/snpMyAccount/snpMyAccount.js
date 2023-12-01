import { LightningElement, track } from 'lwc';
import { NavigationMixin } from "lightning/navigation";
import isGuest from "@salesforce/user/isGuest";
import SUNPOWERICONS from '@salesforce/resourceUrl/SUNPOWERICONS';

/**
* @slot Standard
*/
export default class SnpMyAccount extends NavigationMixin(LightningElement) {

  @track userIconUrl = SUNPOWERICONS + '/usericon.png';
  @track showDropDown = false;

  //Check user logged in or not
  get isGuest() {
    return isGuest;
  }

  // Handles the login action
  handleLogin() {

    this.navigatePage('Login');
  }

  // Handles the registration action
  handleRegister() {
    this.navigatePage('Register');
  }

  // Navigates to a named page using NavigationMixin
  navigatePage(pageName) {
    this[NavigationMixin.Navigate]({
      type: 'comm__namedPage',
      attributes: {
        name: pageName
      }
    });

  }

  //Show or Hide Account Dropdown
  handleShowDropDown() {
    this.showDropDown = !this.showDropDown;
  }


  handleHideDropDown() {
    setTimeout(() => {

      this.showDropDown = false;
    }, 300);


  }

}