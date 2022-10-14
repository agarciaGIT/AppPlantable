import { LightningElement, track } from 'lwc';
import getMembershipDetails from '@salesforce/apex/DashboardController.getMembershipDetails';

export default class MembershipCard extends LightningElement {
    @track memberType;
    @track joinedDate;  
    @track membershipExpiration;
    @track status;
    @track garpMemberId;
    @track showMembershipStatus = false;
    @track showUpgradeButton = false;
    @track showRenewButton = false;
    @track errorMessage;

    connectedCallback(){
        getMembershipDetails().then(result => {
            //alert('result'+JSON.stringify(result));
            this.memberType = result.Membership_Type__c;
            this.joinedDate = result.Date_Joined_view__c;
            this.membershipExpiration = result.KPI_Membership_Expiration_Date__c;
            this.status = result.KPI_Membership_Payment_Status__c;
            this.garpMemberId = result.GARP_Member_ID__c;
            console.log('joined date:'+this.joinedDate);
            console.log('membershipExpiration date:'+this.membershipExpiration);
            
            if(this.memberType == 'Individual' && this.status!=undefined){
                this.showMembershipStatus = true;
            }
            if(this.memberType == 'Affiliate'){
                this.showUpgradeButton = true;
            }
            if(this.memberType == 'Individual' && this.status == 'Lapsed'){
                this.showRenewButton = true;
            }
        })
        .catch(error => {
            //alert('error'+JSON.stringify(error));
            this.errorMessage = error.body.message;
        })
    }
}