import { LightningElement,track } from 'lwc';

export default class CreateAndConformPassword extends LightningElement {

  @track passwordFieldType = 'password';
  @track passwordToggleIcon = "fa fa-eye-slash";
  @track confirmPasswordFieldType = 'password';
  @track confirmPasswordToggleIcon = "fa fa-eye-slash";

  handlePasswordInput(event) {
    // Handle password input logic here
  }

  handleConfirmPasswordInput(event) {
    // Handle confirm password input logic here
  }

  handleFocus(event) {
    event.target.removeAttribute('placeholder');
  }

handleBlur(event) {
    const inputField = event.target;
    if (!inputField.value) {
      inputField.placeholder = 'Create a new password*';
    }
  }

  togglePasswordVisibility() {
    this.passwordFieldType = this.passwordFieldType === 'password' ? 'text' : 'password';
    this.passwordToggleIcon = this.passwordToggleIcon === "fa fa-eye-slash" ? "fa fa-eye" : "fa fa-eye-slash";
  }

  toggleConfirmPasswordVisibility() {
    this.confirmPasswordFieldType = this.confirmPasswordFieldType === 'password' ? 'text' : 'password';
    this.confirmPasswordToggleIcon = this.confirmPasswordToggleIcon === "fa fa-eye-slash" ? "fa fa-eye" : "fa fa-eye-slash";
  }
}
