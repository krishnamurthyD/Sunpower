import { LightningElement, wire} from 'lwc';
import Id from '@salesforce/user/Id';
import marketingEmail from '@salesforce/apex/SNP_Sign_In_controller.marketingEmail';
import makefalseMarketingchechbox from '@salesforce/apex/SNP_Sign_In_controller.makefalseMarketingchechbox';
import guestUser from '@salesforce/user/isGuest';

export default class LWCCurrentUserInfo extends LightningElement {
    error;
    userId = Id;
    currentUserEmail = null;
    marketingforuser = false;

    connectedCallback() {
         // Check if the user is a guest user
        if(!guestUser){
        console.log('2 '+Id);
        }
        else{
            console.log('apple1 guest user');
        }
        
    }

    // Wire service to fetch marketing information for the current user
    @wire(marketingEmail ,{userid:Id})
    getMarketingUserInfo({error,data}){
        if(error){
            // alert('5 '+  JSON.stringify(error));
            console.log('6 '+JSON.stringify(error));
        }else if (data){
            // alert('7 '+JSON.stringify(data))
            console.log('8 '+JSON.stringify(data));
            // alert('9 '+data.PersonEmail);
            console.log('10 '+data.PersonEmail);
            console.log('11 '+data.Marketing_Email__c);

            //assigning values like subscribed or not and email id of user
            this.currentUserEmail = data.PersonEmail;
            this.marketingforuser = data.Marketing_Email__c;

             // Call a method to create a form when data is loaded
            this.createFormIfDataLoaded();
        }
    }

    //craeting form dynamicALLY 
    createFormIfDataLoaded() {
        
        // Call an Apex method to update the marketing checkbox to false
        if(this.marketingforuser){
            makefalseMarketingchechbox(
                {userid:Id}
            )
            .then((data)=>{
                console.log('14 d'+data);
                // alert('15 d'+data)
                console.log('16 d'+JSON.stringify(data));
                // alert('17 d'+JSON.stringify(data))
            })
            .catch((error)=>{
                console.log('18 e'+error);
                // alert('19 e'+error)
                console.log('20 e'+JSON.stringify(error));
                // alert('21 e'+JSON.stringify(error))
            })
        }

         // Create a form element dynamically
        if (this.marketingforuser) {
            // Create the form element
            var form = document.createElement('form');
            form.id = 'myForm';
            form.method = 'post';
            form.action = 'https://www3.lenoxsoft.com/l/555143/2023-11-17/7h7wsh';

            // Create an input element for email
            var inputEmail = document.createElement('input');
            inputEmail.type = 'text';
            inputEmail.id = 'email';
            inputEmail.name = 'email';
            inputEmail.value = this.currentUserEmail;
            form.appendChild(inputEmail);

            // Append the form to the body
            document.body.appendChild(form);

            // Submit the form
            // form.submit();
        }
    }
}

