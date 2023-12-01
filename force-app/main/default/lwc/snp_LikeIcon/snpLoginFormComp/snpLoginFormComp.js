import { LightningElement, track } from 'lwc';
import doLogin from '@salesforce/apex/CommunityAuthController.doLogin';
import { NavigationMixin } from 'lightning/navigation';


export default class SnpLoginFormComp extends NavigationMixin(LightningElement) {
    username;
    password;
    @track errorCheck;
    @track errorMessage;
    ispassword=true;
    emailerrormsg=false;
    connectedCallback(){

        // var meta = document.createElement("meta");
        // meta.setAttribute("name", "viewport");
        // meta.setAttribute("content", "width=device-width, initial-scale=1.0");
        // document.getElementsByTagName('head')[0].appendChild(meta);
        
    }

    handleUserNameChange(event){

        this.username = event.target.value;
    }

    handlePasswordChange(event){
        
        this.password = event.target.value;
    }
    forgotpasswordhandler(){
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name:'Forgot_Password',
            }
        });
    }
    signuphandler(){
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name:'Register',
            }
        });
    }
    passwordtoggle(event){
        console.log("hode");
        var passwordField = this.template.querySelector('input[data-id="inputPassword"]');
        var eyeSign = this.template.querySelector('.fa');
        console.log(eyeSign);
        // toggle the type attribute
        const type = passwordField.getAttribute('type') === 'password' ? 'text' : 'password';
        passwordField.setAttribute('type', type);
        // toggle the eye / eye slash icon
        //eyeSign.classList.toggle('fa-eye');
        if (passwordField.type === "password") {
            this.ispassword=true;
          } else {
            this.ispassword=false;;
          }
        }
    
    handleLogin(event){
        const emailRegex=/^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        let email = this.template.querySelector('input[data-id="inputUsername"]');
        let emailVal=email.value.trim();
        if(emailVal.match(emailRegex)){
             if(this.username && this.password){

                event.preventDefault();
        
                doLogin({ username: this.username, password: this.password })
                    .then((result) => {
                        console.log('**'+result);
                        window.location.href = result;
                    })
                    .catch((error) => {
                        console.log('&&'+JSON.stringify(error));
                        this.error = error;      
                        this.errorCheck = true;
                        this.errorMessage = error.body.message;
                    });
                    this.emailerrormsg=false;
                }
             }
         else{
            this.emailerrormsg=true;

        }
           
    }

}