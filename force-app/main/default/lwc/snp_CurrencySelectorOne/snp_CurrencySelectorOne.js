import { LightningElement, track } from 'lwc';
import activeLanguages from '@salesforce/site/activeLanguages';
import userlang from '@salesforce/apex/Product2Controller.userlang';
import guestUser from '@salesforce/user/isGuest';
import UserId from '@salesforce/user/Id';

export default class Snp_CurrencySelectorOne extends LightningElement {
    currentValue;
    selectedLanguageCode;
    checkuser=true;

    get options() {
        console.log('activeLanguages'+JSON.stringify(activeLanguages));
        this.countryes = activeLanguages.code;

        return activeLanguages.map((x) => ({ value: x.code, ...x }));
    }
    //currentValue= currentLanguage;
    handleLanguageSelect(evt) {
    // debugger;
    this.selectedLanguageCode = evt.detail.value;
    // this.guestUserChangeCurrency();
    if(!guestUser){
        this.checkuser= true;
        userlang({locale :this.selectedLanguageCode, userId : UserId})
        .then((result)=>{
        var url =window.location.href;
        window.location.href=url;
        window.location.href;
        //console.log("result"+ result);
        })
        .catch((error)=>{
        console.log("error"+ error);
        })
    }else{
        this.checkuser= false;
    }
}
}