import { LightningElement, track, wire } from 'lwc';
import getMatches from '@salesforce/apex/IplServices.getMatches';
import { subscribe, MessageContext,APPLICATION_SCOPE } from 'lightning/messageService';
import IPLMC from '@salesforce/messageChannel/IplMessageChannel__c';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'; 

const columns = [
    { label: 'Match No', fieldName: 'Match_No__c' },
    { label: 'Day', fieldName: 'Day__c', type: 'text' },
    { label: 'Date', fieldName: 'Date__c', type: 'text' },
    { label: 'Match', fieldName: 'Match__c', type: 'text' },
    { label: 'Venue', fieldName: 'Venue__c', type: 'text' },
];
export default class ShowMatches extends LightningElement {
    data = [];
    arr = [];
    cnt = 0;
    columns = columns;

    label1 = '';
    label2 = '';

    @wire(MessageContext)
    messageContext;


    @wire(getMatches,{team1:'$label1', team2:'$label2'})
    wiredMatches({error,data}){
        console.log("In getmatches");
        if(data){
            
            console.log(this.arr.length);
            this.data = data;
            console.log(data);
        } else {
            console.log("Error"+error);
        }
    }
    

    subscribeMC(){
        subscribe(
            this.messageContext,
            IPLMC,
            (message) => { this.label1 = message.team1L; this.label2 = message.team2L; console.log(this.label1); console.log(this.label2);},
            {scope: APPLICATION_SCOPE}
        )
    }

    getSelectedMatch(event){
        const selectedRows = event.detail.selectedRows;
        for (let i = 0; i < selectedRows.length; i++) {
            const match = selectedRows[i].Match_No__c;
            const result = this.arr[match-1].result;
            const toast = new ShowToastEvent({
                title:'Winner',
                message:result,
                variant:'success'
            });
            this.dispatchEvent(toast);
        }
    }

    connectedCallback(){
        this.subscribeMC();
        
    }
}