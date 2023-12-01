import { LightningElement, wire } from 'lwc';
import getTeams from '@salesforce/apex/IplServices.getTeams';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'; 
import { publish,MessageContext } from 'lightning/messageService';
import IPLMC from '@salesforce/messageChannel/IplMessageChannel__c';

export default class SelectTeams extends LightningElement {
    teams = [];
    error;

    teamOneLabel = '';
    teamTwoLabel = '';

    teamOneId;
    teamTwoId;

    teamOneName;
    teamTwoName;

    @wire(MessageContext)
    messageContext;

    @wire(getTeams)
    wiredTeams({data,error}){
        if(data){
            this.teams = data;
            this.error = undefined;
        } else if(error){
            this.teams = undefined;
            this.error = error;
        }
    }

    onTeam1Change(event){
        if(event.target.value === this.teamTwoId){
            this.teamOneId = undefined;

            const toast = new ShowToastEvent({
                title:'Error',
                message:'Choose a different team',
                variant:'error'
            })
            this.dispatchEvent(toast)
        } else {
            this.teamOneId = event.target.value
            this.teamOneName = event.target.dataset.name
            this.teamOneLabel = event.target.dataset.label;
        const message = {
            team1:this.teamOneId,
            team2:this.teamTwoId,
            team1L:this.teamOneLabel,
            team2L:this.teamTwoLabel
        }
        publish(this.messageContext,IPLMC,message);
        }
    }
    onTeam2Change(event){
        if(event.target.value === this.teamOneId){
            this.teamTwoId = undefined;

            const toast = new ShowToastEvent({
                title:'Error',
                message:'Choose a different team',
                variant:'error'
            })
            this.dispatchEvent(toast)
        } else {
            this.teamTwoId = event.target.value
            this.teamTwoName = event.target.dataset.name
            this.teamTwoLabel = event.target.dataset.label;
        const message = {
            team1:this.teamOneId,
            team2:this.teamTwoId,
            team1L:this.teamOneLabel,
            team2L:this.teamTwoLabel
        }
        publish(this.messageContext,IPLMC,message);
        }   
    }
    sendMessageService1(teamId){
        console.log("In sendMessageService1" + teamId);
        publish(this.messageContext, IPLMC, {recordId:teamId});
    }
    sendMessageService2(teamId){
        console.log("In sendMessageService1" + teamId);
        publish(this.messageContext, IPLMC, {recordId:teamId});
    }
    handleReset(){
        eval("$A.get('e.force:refreshView').fire();");
    }
}