import { LightningElement, wire } from 'lwc';
import getNews from '@salesforce/apex/IplServices.getNews';

export default class NewsCmp extends LightningElement {
    news;
    @wire(getNews)
    wiredNews({error,data}){
        if(data){
            this.news = data;
            console.log(this.news);
        } else {
            console.log("Error"+error);
        }
    }
}