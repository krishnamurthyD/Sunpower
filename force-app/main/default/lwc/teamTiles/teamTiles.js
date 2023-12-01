import { LightningElement, wire } from 'lwc';
import { subscribe, MessageContext,APPLICATION_SCOPE } from 'lightning/messageService';
import IPLMC from '@salesforce/messageChannel/IplMessageChannel__c';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import getATeam from '@salesforce/apex/IplServices.getATeam';
import TEAM_ID_FIELD from '@salesforce/schema/Team__c.Id'
import TEAM_NAME_FIELD from '@salesforce/schema/Team__c.Name'
import TEAM_PICTURE_FIELD from '@salesforce/schema/Team__c.Picture__c'
import TEAM_OWNERNAME_FIELD from '@salesforce/schema/Team__c.Owner__c'

const TEAM_FIELDS = [TEAM_ID_FIELD, TEAM_NAME_FIELD, TEAM_OWNERNAME_FIELD, TEAM_PICTURE_FIELD];

export default class TeamTiles extends LightningElement {
    team1Id;
    team1;

    team2Id;
    team2;

    @wire(MessageContext)
    messageContext;

    @wire(getRecord,{recordId:'$team1Id',fields:TEAM_FIELDS})
    wiredRecord({error,data}){
        if(data){
            this.team1 = data
            console.log(this.team1.fields);
        } else {
            console.log(error);
        }
    }

    @wire(getRecord,{recordId:'$team2Id',fields:TEAM_FIELDS})
    wiredRecord1({error,data}){
        if(data){
            this.team2 = data
            console.log(this.team2.fields);
        } else {
            console.log(error);
        }
    }

    subscribeMC(){
        
        subscribe(
            this.messageContext,
            IPLMC,
            (message) => {this.team1Id = message.team1; this.team2Id=message.team2},
            {scope : APPLICATION_SCOPE}
        )

       
        
    }

    get backgroundStyle1(){
        if(this.team1){
            return 'background-image:url('+ this.team1.fields.Picture__c.value +')';
        } else {
            return "background-image:url('/resource/iplteams/NONE.png')";
            
        }
        
    }

    get backgroundStyle2(){
        if(this.team2){
            return 'background-image:url('+ this.team2.fields.Picture__c.value +')';
        } else {
            return "background-image:url('/resource/iplteams/NONE.png')";
            
        }
        
    }

    connectedCallback(){
        this.subscribeMC();
    }
}