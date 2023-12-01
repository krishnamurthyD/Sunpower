import { LightningElement } from 'lwc';

export default class RadioButton extends LightningElement {
    value='';
   get options(){
    return [
        {label:'Male',value:'Male'},
        {label:'Female',value:'Female'},
        {label:'Others',value:'Others'}
    ]
   } 
}