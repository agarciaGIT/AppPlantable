import { LightningElement, api, track, wire } from 'lwc';
import getExamAlerts from '@salesforce/apex/GARP_MC_MemberNotifications.getExamAlerts';
import { util_isDefined, util_console } from 'c/common';
import { registerListener, unregisterAllListeners } from 'c/pubsub';


export default class custMemberNotificationsExamAlerts extends LightningElement {
    @track sObjData= [];
    @track haveUnread = false;
    @track pageRef = {name: 'GARP-USER-PORTAL'};

    checkMessage() {
        getExamAlerts({})
        .then(result =>{
            util_console('getExamAlerts',result);
            if (util_isDefined(result)) {
                this.haveUnread = false;
                if(result.find(element => element.Is_Viewed_In_Portal__c == false)) {
                    this.haveUnread = true;
                }
            }
        })
        .catch(error =>{
            this.errorMsg = error;
        })            
    }

    handleMessage(event){
        util_console('Stream Event' + event.detail);
        this.checkMessage();
    }

    handleError(event){
        util_console('Stream Event Error' + event.detail.error);
    }

    connectedCallback() {
        registerListener('readNotification', this.OnReadMessage, this);
        this.checkMessage();
    }

    disconnectedCallback() {
        unregisterAllListeners(this);
    }
    
    OnReadMessage(data) {
        util_console('Stream Event Error' + data);        
        this.checkMessage(); 
    }    
}