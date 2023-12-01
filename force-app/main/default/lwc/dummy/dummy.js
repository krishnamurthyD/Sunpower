import { LightningElement } from 'lwc';

export default class Dummy extends LightningElement {
    connectedCallback(){
        alert('hi');
    }
}