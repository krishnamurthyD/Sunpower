import { LightningElement, track } from 'lwc';

export default class UlLiselectOption extends LightningElement {
    @track selectedOption = 'Select Options';
    @track showOptions = false;

    Options = ['One', 'Two', 'Three', 'Four', 'Five', 'Six', 'Seven'];

    handleOptionClick(event) {
        this.selectedOption = event.target.innerText;
        //const allOption = this.template.querySelectorAll("option");
        console.log(event.currentTarget.innerText);
    }

    toggleOptions() {
        this.showOptions = !this.showOptions;
    }

}
