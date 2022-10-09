import { LightningElement, api, track, wire } from 'lwc';
import getExamAlerts from '@salesforce/apex/GARP_MC_MemberNotifications.getExamAlerts';
import { util_isDefined, util_navigate } from 'c/common';


export default class custMemberNotificationsExamAlerts extends(LightningElement) {
    @track sObjData= [];

    connectedCallback() {

        this.addEventListener("sampleresponse", (e) => {
            console.log('Message Sent: ' + e.detail);
        });

        getExamAlerts({ })
        .then(result =>{

            var res = [];
            for(i=0; i<result.length && i<5; i++) {
                res.push(result[i]);
            }

            this.sObjData = res;
        })
        .catch(error =>{
            this.errorMsg = error;
        })
    }

    clickViewNotification(event){
        util_navigate(this, 'notifications', {NOTIFICATION_ID: null});
    }

    clickViewNotificationId(event){
        util_navigate(this, 'notifications', {NOTIFICATION_ID: event.target.dataset.id});
    }
}