import { LightningElement, api, track, wire } from 'lwc';
import getExamAlerts from '@salesforce/apex/GARP_MC_MemberNotifications.getExamAlerts';
import setMemberNotificationAsViewed from '@salesforce/apex/GARP_MC_MemberNotifications.setMemberNotificationAsViewed';
import { util_isDefined, util_console } from 'c/common';
import { fireEvent } from 'c/pubsub';

export default class custMemberNotificationsExamAlerts extends LightningElement {
    @api notificationId;
    @track sObjData= [];
    firstLoad = true;

    connectedCallback() {
        this.checkMessage();
    }

    checkMessage() {
        getExamAlerts({ })
        .then(result =>{
            util_console('getExamAlerts',result);
            this.sObjData = result;
        })
        .catch(error =>{
            util_console('getExamAlerts error',error);
            this.errorMsg = error;
        })            
    }

    renderedCallback() {
        if(util_isDefined(this,"sObjData.length") && this.sObjData.length > 0) {
            if(this.firstLoad && util_isDefined(this.notificationId) && this.notificationId.length > 0) {
                this.toggelDetails(this.notificationId);
            }
            this.firstLoad = true;
        }
    }

    @track pageRef = {name: 'GARP-USER-PORTAL', source: 'memberNotificationsExamAlerts'};
    trackView(event){
        this.toggelDetails(event.target.dataset.id);
    }

    toggelDetails(notificationId) {
        util_console('view notification',notificationId);

        const annoucement = this.template.querySelector('p[data-id="' + notificationId + '"]');
        const chevSide = this.template.querySelector('.side-chev[data-id="' + notificationId + '"]');
        const chevDown = this.template.querySelector('.down-chev[data-id="' + notificationId + '"]');

        if(util_isDefined(annoucement,"style.display") && util_isDefined(chevSide,"style.display") && util_isDefined(chevDown,"style.display")) {
            annoucement.style.display == 'none' ? annoucement.style.display = '' : annoucement.style.display = 'none';
            chevSide.style.display == '' ? chevSide.style.display = 'none' : chevSide.style.display = '';
            chevDown.style.display == 'none' ? chevDown.style.display = '' : chevDown.style.display = 'none';

            if(annoucement.style.display == '') {
                setMemberNotificationAsViewed({recNotId: notificationId})
                .then(result =>{
                    util_console('setMemberNotificationAsViewed',result);
                    this.contacts = result;
                    fireEvent(this.pageRef, 'readNotification', result);
                })
                .catch(error =>{
                    util_console('setMemberNotificationAsViewed error',error);
                    this.errorMsg = error;
                })    
            }   
        }
    }

    handleMessage(event){
        util_console('Stream Event' + event.detail);
        this.checkMessage();
    }

    handleError(event) {
        util_console('Stream Event Error' + event.detail.error);
    }

}