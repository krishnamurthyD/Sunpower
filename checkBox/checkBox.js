import { LightningElement, track } from 'lwc';

export default class Checkbox extends LightningElement {
  @track isChecked = false;
  @track isHovered = false;

  get checkboxLabelClass() {
    return this.isChecked ? 'checkbox-label checked' : 'checkbox-label';
  }

  handleCheckboxChange(event) {
    this.isChecked = event.target.checked;
  }

  handleCheckboxHover() {
    this.isHovered = !this.isHovered;
  }
}
